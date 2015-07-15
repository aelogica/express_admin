module ExpressAdmin
  class SmartTable < ExpressTemplates::Components::Configurable
    include ExpressTemplates::Components::Capabilities::Resourceful

    MAX_COLS_TO_SHOW_IDX = 5

    attr :columns

    emits -> {
      table(id: config[:id], class: 'table striped') {
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
          helpers.collection.each do |item|
            tr(id: row_id(item), class: row_class(item)) {
              display_columns.each do |column|
                td(class: column.name) {
                  cell_value(item, column.accessor)
                }
              end
              actions_column(item) if should_show_actions?
              hidden_column_cell if columns_hidden?
            }
          end ; nil
        }
      }

      scroll_table if !!config[:scroll_table]
    }

    def scroll_table
      script {
        %Q($('\##{my[:id]}').scrollTableBody())
      }
    end

    def actions_header
      th(class: 'actions') { 'Actions' }
    end

    def should_show_actions?
      config[:actions].nil? || !!config[:actions]
    end

    def resource_path(item)
      helpers.send(resource_path_helper, item.to_param)
    end

    def actions_column(item)
      td {
        link_to 'Delete', resource_path(item), method: :delete, data: {confirm: 'Are you sure?'}, class: 'button small secondary'
      }
    end

    def row_class(item)
      if config[:row_class].try(:respond_to?, :call)
        config[:row_class].call(item)
      else
        item.eql?(helpers.resource) ? 'current' : ''
      end
    end

    def is_permanent?
      config[:permanent].nil? || (config[:permanent].present? && config[:permanent])
    end

    def row_id(item)
      "#{collection_member_name}:#{item.to_param}"
    end

    def cell_value(item, accessor)
      if accessor.respond_to?(:call)
        value = begin
            accessor.call(item).to_s
          rescue
            'Error: '+$!.to_s
          end
      elsif attrib = accessor.to_s.match(/(\w+)_link$/).try(:[], 1)
        # TODO: only works with non-namespaced routes
        value = link_to item.send(attrib), resource_path(item)
      elsif attrib = accessor.to_s.match(/(\w+)_in_words/).try(:[], 1)
        value = item.send(attrib) ? (time_ago_in_words(item.send(attrib))+' ago') : 'never'
      else
        if relation_name = accessor.to_s.match(/(.*)_id$/).try(:[], 1)
          reflection = resource_class.reflect_on_association(relation_name.to_sym)
        end

        value = if reflection
          relation = item.send(relation_name)
          relation.try(:name) || relation.to_s
        else
          item.send(accessor)
        end
      end
      span {
        value
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
