module ExpressAdmin
  class SmartTable < ExpressTemplates::Components::Base
    include ExpressTemplates::Components::Capabilities::Configurable

    MAX_COLS_TO_SHOW_IDX = 7

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
            show_hidden_columns_header_indicator if columns_hidden?
          }
        }
        tbody {
          for_each(collection_var) {
            tr(id: row_id, 'data-resource-url': "{{admin_#{collection_member_name}_path(#{collection_member_name}.id)}}") {
              display_columns.each do |column|
                td.send(column.name) {
                  cell_value(column.name)
                }
              end
              show_hidden_column_cell if columns_hidden?
            }
          }
        }
      }
      script {
        %Q(
          $(document).on('click', 'tr', function(e){
            e.preventDefault();
            window.location = $(this).attr('data-resource-url');
          })
        )
      }
    }

    def row_id
      "#{collection_member_name}-{{#{collection_member_name}.id}}"
    end

    def collection_member_name
      @config[:id].to_s.singularize
    end

    def collection_var
      "@#{collection_member_name.pluralize}".to_sym
    end

    def cell_value(column_name)
      "{{#{collection_member_name}.#{column_name}}}"
    end

    def display_columns
      columns.slice(0..MAX_COLS_TO_SHOW_IDX)
    end

    def columns_hidden?
      columns.size > MAX_COLS_TO_SHOW_IDX+1
    end

    def show_hidden_columns_header_indicator
      th._more_columns_indicator {
        "..."
      }
    end

    def show_hidden_column_cell
      td._more_columns_indicator
    end

    def columns
      resource_class.constantize.content_columns
    end

    def resource_class
      # TODO: Module namespace needs to be guessed somehow
      "ExpressCms::#{collection_member_name.classify}"
    end
  end
end
