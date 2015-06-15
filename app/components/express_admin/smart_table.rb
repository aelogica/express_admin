module ExpressAdmin
  class SmartTable < ExpressTemplates::Components::Base
    include ExpressTemplates::Components::Capabilities::Configurable
    include ExpressTemplates::Components::Capabilities::Resourceful

    MAX_COLS_TO_SHOW_IDX = 5

    attr :columns

    emits -> {
      table(my[:id], options)._table_hover {
        thead {
          tr {
            display_columns.each do |column|
              th.send(column.name) {
                div { # wrap in div so we can use overflow
                  column.title
                }
              }
            end
            actions_header if should_show_actions?
            hidden_columns_header_indicator if columns_hidden?
          }
        }
        tbody {
          for_each(collection, as: collection_member_name) {
            tr(row_args) {
              display_columns.each do |column|
                td.send(column.name) {
                  cell_value(column.accessor)
                }
              end
              actions_column if should_show_actions?
              hidden_column_cell if columns_hidden?
            }
          }
        }
      }
      if @config[:show_on_click]
        if is_permanent?
          script {
            %Q(
              $(document).on('click', 'tr', function(e){
                e.preventDefault();
                Turbolinks.visit($(this).attr('data-resource-url'), { cacheRequest: false });
              })
            )
          }
        else
          script {
            %Q(
              $(document).on('click', 'tr', function(e){
                e.preventDefault();
                Turbolinks.visit($(this).attr('data-resource-url'), { cacheRequest: false, change: 'main' });
              })
            )
          }
        end

      end

      scroll_table if !!@config[:scroll_table]
    }

    def scroll_table
      script {
        %Q($('\##{my[:id]}').scrollTableBody())
      }
    end

    def options
      if is_permanent?
        {'data-turbolinks-permanent': nil}
      else
        nil
      end
    end

    def actions_header
      th.actions { 'Actions' }
    end

    def should_show_actions?
      @config[:actions].nil? || !!@config[:actions]
    end

    def actions_column
      td {
        link_to 'Delete', "{{#{resource_path}}}", method: :delete, data: {confirm: 'Are you sure?'}, class: 'button tiny secondary'
      }
    end

    def row_class
      @config[:row_class].try(:respond_to?, :call) ? 
        "{{#{@config[:row_class].source}.call(#{collection_member_name})}}" : 
        "{{#{collection_member_name}.eql?(@#{resource_name}) ? 'current' : ''}}"
    end

    def is_permanent?
      @config[:permanent].nil? || (@config[:permanent].present? && @config[:permanent])
    end

    def row_id
      "#{collection_member_name}:{{#{collection_member_name}.id}}"
    end

    def row_args
      row_args = {id: row_id, class: row_class}
      row_args.merge!('data-resource-url': "{{#{resource_path}}}") if !!@config[:show_on_click]
      row_args
    end

    def cell_value(accessor)
      if accessor.respond_to?(:call)
        value = "(begin #{accessor.source}.call(#{collection_member_name}).to_s rescue 'Error: '+$!.to_s ; end)"
      elsif attrib = accessor.to_s.match(/(\w+)_link$/).try(:[], 1)
        value = "(link_to #{collection_member_name}.#{attrib}, #{collection_member_name}_path(#{collection_member_name}))"
      elsif attrib = accessor.to_s.match(/(\w+)_in_words/).try(:[], 1)
        value = "(#{collection_member_name}.#{attrib} ? time_ago_in_words(#{collection_member_name}.#{attrib})+' ago' : 'never')"
      else
        if relation_name = accessor.to_s.match(/(.*)_id$/).try(:[], 1)
          reflection = resource_class.reflect_on_association(relation_name.to_sym)
        end

        value = if reflection
          relation = "#{collection_member_name}.#{relation_name}"
          "#{relation}.try(:name) || #{relation}.to_s"
        else
          "#{collection_member_name}.#{accessor}"
        end
      end
      span {
        "{{#{value}}}"
      }
    end

    def display_columns
      specified_columns? ? columns : columns.slice(1..MAX_COLS_TO_SHOW_IDX)
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

    def columns
      @columns ||= _initialize_columns
    end

    def specified_columns?
      !!specified_columns
    end

    def specified_columns
      @config[:columns]
    end

    def hidden_columns_header_indicator
      th._more_columns_indicator {
        "..."
      }
    end

    def hidden_column_cell
      td._more_columns_indicator
    end

    private
      def _initialize_columns
        @columns =
          if specified_columns.kind_of?(Array)
            specified_columns.map { |name| Column.new(name) }

          elsif specified_columns.kind_of?(Hash)
            specified_columns.map { |title, accessor| Column.new(accessor, title) }

          else
            attributes.map { |column| Column.new(column.name.to_sym) }
          end
      end

  end
end
