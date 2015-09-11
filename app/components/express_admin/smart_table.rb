module ExpressAdmin
  module Components
    module Presenters
      class SmartTable < ExpressTemplates::Components::Configurable
        include ExpressTemplates::Components::Capabilities::Resourceful

        tag :div

        MAX_COLS_TO_SHOW_IDX = 5
        MAX_ROWS_TO_SHOW_IDX = 10

        attr :columns

        has_option :scrollable, 'Set to true if the table should be scrollable', type: :boolean, default: false
        has_option :show_actions, 'Set to true if table has actions for each row'
        has_option :row_class, 'Add a class to each table row'

        column_defs = {}
        column_defs[:array] = {description: "List of fields to include in the table as columns",
                               options: -> { resource.columns.map(&:name)} }
        column_defs[:hash] = {description: "Hash of column names (titles) and how to calculate the cell values."}

        has_option :columns, 'Specify the columns.  May provide as a hash with values used to provide cell values as a proc.',
                             type: [:array, :hash],
                             values: -> (*) {
                               options = resource_class.columns.map(&:name)
                               resource_class.columns.map(&:name).each do |name|
                                 options << if name.match(/(\w+)_at$/)
                                              "#{name}_in_words"
                                            else
                                              "#{name}_link"
                                            end
                               end
                               options = options + resource_class.instance_methods.grep(/_count$/).map(&:to_s)
                             }
        has_option :rows, 'Specify the number of rows to show', type: :integer

        has_option :pagination, 'Add pagination to the bottom of the table', type: :string, default: 'bottom'

        contains -> {
          pagination if config[:pagination] == 'top'
          table(class: table_classes) {
            thead {
              tr {
                display_columns.each do |column|
                  th(class: column.name) {
                    column.title
                  }
                end
                actions_header if should_show_actions?
                hidden_columns_header_indicator if columns_hidden?
              }
            }
            tbody {
              stored_member_assigns = assigns[collection_member_name.to_sym]
              collection.each do |item|
                assigns[collection_member_name.to_sym] = item
                tr(id: row_id(item), class: row_class(item)) {
                  display_columns.each do |column|
                    td(class: column.name) {
                      cell_value(item, column.accessor)
                    }
                  end
                  actions_column(item) if should_show_actions?
                  hidden_column_cell if columns_hidden?
                }
                assigns[collection_member_name.to_sym] = stored_member_assigns
              end; nil
            }
          }
          scroll_table if !!config[:scrollable]
          pagination if config[:pagination] == 'bottom'
        }

        before_build -> {
          _initialize_columns
        }

        def pagination
          paginate collection, :route_set => route_set
        end

        def table_classes
          'table striped'
        end

        def route_set
          namespace.nil? ? namespace : eval(namespace)
        end

        def collection
          collections = super.kind_of?(Array) ? Kaminari.paginate_array(super) : super
          collections.page(index_page).per(specified_rows)
        end

        def index_page
          helpers.params[:page] || 1 # Default page is 1
        end

        def scroll_table
          script {
            %Q($('\##{config[:id]}').scrollTableBody())
          }
        end

        def actions_header
          th(class: 'actions') { 'Actions' }
        end

        def should_show_actions?
          !!config[:show_actions]
        end

        def should_show_delete?(item)
          if item.respond_to?(:can_delete?) && item.can_delete?
            true
          elsif !item.respond_to?(:can_delete?)
            true
          else
            false
          end
        end

        def actions_column(item)
          td {
            if should_show_delete?(item)
              link_to 'Delete', resource_path(item), method: :delete, data: {confirm: 'Are you sure?'}, class: 'button small secondary'
            end
          }
        end

        def row_class(item)
          if config[:row_class].try(:respond_to?, :call)
            config[:row_class].call(item)
          else
            item.eql?(resource) ? 'current' : ''
          end
        end

        def row_id(item)
          "#{collection_member_name}:#{item.to_param}"
        end

        def cell_value(item, accessor)
          value = if accessor.respond_to?(:call)
                    begin
                      accessor.call(item).try(:html_safe)
                    rescue
                      'Error: '+$!.to_s
                    end
                  elsif attrib = accessor.to_s.match(/(\w+)_link$/).try(:[], 1)
                    # TODO: only works with non-namespaced routes
                    helpers.link_to item.send(attrib), resource_path(item)
                  elsif attrib = accessor.to_s.match(/(\w+)_checkmark/).try(:[], 1)
                    "<i class='ion-checkmark-round'></i>".html_safe if item.send(attrib)
                  elsif attrib = accessor.to_s.match(/(\w+)_in_words/).try(:[], 1)
                    if item.send(attrib)
                      if item.send(attrib) < DateTime.now
                        "#{helpers.time_ago_in_words(item.send(attrib))} ago"
                      else
                        "in #{helpers.time_ago_in_words(item.send(attrib))}"
                      end
                    else
                      'never'
                    end
                  else
                    if relation_name = accessor.to_s.match(/(.*)_id$/).try(:[], 1)
                      reflection = resource_class.reflect_on_association(relation_name.to_sym)
                    end

                    if reflection
                      relation = item.send(relation_name)
                      relation.try(:name) || relation.to_s
                    else
                      item.send(accessor)
                    end
                  end
          current_arbre_element.add_child value
        end

        def display_columns
          specified_columns? ? @columns : @columns.slice(1..MAX_COLS_TO_SHOW_IDX)
        end

        def columns_hidden?
          !specified_columns? && columns.size > MAX_COLS_TO_SHOW_IDX+1
        end

        class Column
          attr :name, :title, :accessor
          def initialize(accessor, title = nil)
            @name = accessor.kind_of?(Symbol) ? accessor.to_s.underscore : title.titleize.gsub(/\s+/,'').underscore
            @accessor = accessor
            @title = title || @name.titleize
          end
        end

        def specified_columns?
          !!specified_columns
        end

        def specified_columns
          config[:columns]
        end

        def hidden_columns_header_indicator
          th(class: 'more-columns-indicator') {
            "..."
          }
        end

        def hidden_column_cell
          td(class: 'more-columns-indicator')
        end

        def specified_rows
          config[:rows] || MAX_ROWS_TO_SHOW_IDX
        end

        def hidden_columns_header_indicator
          th(class: 'more-columns-indicator') {
            "..."
          }
        end

        private
          def _initialize_columns
            @columns =
              if specified_columns.kind_of?(Array)
                specified_columns.map { |name| Column.new(name) }

              elsif specified_columns.kind_of?(Hash)
                specified_columns.map { |title, accessor| Column.new(accessor, title) }

              else
                resource_attributes.map { |column| Column.new(column.name.to_sym) }
              end
          end

      end
    end
  end
end
