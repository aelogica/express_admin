module ExpressAdmin
  class SmartTable < ExpressTemplates::Components::Base
    include ExpressTemplates::Components::Capabilities::Configurable
    include ExpressTemplates::Components::Capabilities::Resourceful

    MAX_COLS_TO_SHOW_IDX = 5

    emits -> {
      table(my[:id], 'data-turbolinks-permanent': nil)._table_hover {
        thead {
          tr {
            display_columns.each do |column|
              th.send(column.name) {
                div { # wrap in div so we can use overflow
                  column.name.titleize
                }
              }
            end
            th.actions { 'Actions' }
            show_hidden_columns_header_indicator if columns_hidden?
          }
        }
        tbody {
          for_each(collection_var) {
            tr(id: row_id, 'data-resource-url': "{{#{resource_path}}}") {
              display_columns.each do |column|
                td.send(column.name) {
                  cell_value(column.name)
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
      if @config[:show_on_click]
        script {
          %Q(
            $(document).on('click', 'tr', function(e){
              e.preventDefault();
              Turbolinks.visit($(this).attr('data-resource-url'), { cacheRequest: false, change: '#{collection_member_name.dasherize}-box' });
            })
          )
        }
      end
    }


    def row_id
      "#{collection_member_name}:{{#{collection_member_name}.id}}"
    end

    def cell_value(column_name)
      if relation_name = column_name.match(/(.*)_id$/).try(:[], 1)
        reflection = resource_klass.reflect_on_association(relation_name.to_sym)
      end

      value = if reflection
        relation = "#{collection_member_name}.#{relation_name}"
        "#{relation}.try(:name) || #{relation}.to_s"
      else
        "#{collection_member_name}.#{column_name}"
      end
      "{{(#{value}).to_s.truncate(27)}}"
    end

    def display_columns
      specified_columns || columns.slice(1..MAX_COLS_TO_SHOW_IDX)
    end

    def columns_hidden?
      !!specified_columns || columns.size > MAX_COLS_TO_SHOW_IDX+1
    end

    def specified_columns
      if @config[:columns]
        columns.select { |column| @config[:columns].include?(column.name.to_sym) }
      end
    end

    def show_hidden_columns_header_indicator
      th._more_columns_indicator {
        "..."
      }
    end

    def show_hidden_column_cell
      td._more_columns_indicator
    end

  end
end
