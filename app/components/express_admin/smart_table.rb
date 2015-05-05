module ExpressAdmin
  class SmartTable < ExpressTemplates::Components::Base
    include ExpressTemplates::Components::Capabilities::Configurable

    MAX_COLS_TO_SHOW_IDX = 7

          require 'pry'

    emits -> {
      table(my[:id]) {
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
            tr(id: row_id) {
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
      th.more_columns_indicator {
        "..."
      }
    end

    def show_hidden_column_cell
      td.more_columns_indicator
    end

    def columns
      resource_class.constantize.columns
    end

    def resource_class
      "ExpressCms::#{collection_member_name.classify}"
    end
  end
end
