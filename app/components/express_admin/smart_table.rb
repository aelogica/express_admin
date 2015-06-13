module ExpressAdmin
  class SmartTable < ExpressTemplates::Components::Base
    include ExpressTemplates::Components::Capabilities::Configurable
    include ExpressTemplates::Components::Capabilities::Resourceful

    MAX_COLS_TO_SHOW_IDX = 5

    attr :columns

    emits -> {
      table(my[:id])._table_hover {
        thead {
          tr {
            display_columns.each do |column|
              th.send(column.name) {
                div { # wrap in div so we can use overflow
                  column.title
                }
              }
            end
            th.actions { 'Actions' }
            show_hidden_columns_header_indicator if columns_hidden?
          }
        }
        tbody {
          for_each(collection_var) {
            tr(id: row_id, 'data-resource-url': "{{#{resource_path}}}", class: row_class) {
              display_columns.each do |column|
                td.send(column.name) {
                  cell_value(column.accessor)
                }
              end
              td {
                link_to 'Delete', "{{#{resource_path}}}", method: :delete, data: {confirm: 'Are you sure?'}, class: 'button tiny secondary'
              }
              show_hidden_column_cell if columns_hidden?
            }
          }
        }
      }
      if !!@config[:show_on_click]
        script {
          %Q(
            $(document).on('click', 'tr', function(e){
              e.preventDefault();
              Turbolinks.visit($(this).attr('data-resource-url'), { cacheRequest: false, change: ['#{collection_member_name.dasherize}-box', '#{my[:id]}'] });
            })
          )
        }
      end
    }

    def row_class
      "{{#{collection_member_name}.eql?(@#{resource_name}) ? 'current' : ''}}"
    end


    def row_id
      "#{collection_member_name}:{{#{collection_member_name}.id}}"
    end

    def cell_value(accessor)
      if accessor.respond_to?(:call)
        value = "(#{accessor.source}.call(#{collection_member_name}) rescue 'Error')"
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
      "{{(#{value}).to_s.truncate(27)}}"
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

    def show_hidden_columns_header_indicator
      th._more_columns_indicator {
        "..."
      }
    end

    def show_hidden_column_cell
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
