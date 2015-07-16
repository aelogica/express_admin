require 'test_helper'

module Components

  class SmartTableTest < ActiveSupport::TestCase

    fixtures :widgets, :categories

    def resource_assigns
      {resource: Widget.new, collection: Widget.all}
    end
    def helpers
      view = mock_action_view(resource_assigns)
      class << view
        def widget_path(widget_id)
          "/widgets/#{widget_id.to_param}"
        end
        alias resource_path widget_path
      end
      view
    end
    def compiled_widget_table(*args)
      arbre {
        smart_table(:widgets, *args)
      }
    end

    test "should have hidden columns" do
      assert_match 'more-columns-indicator', compiled_widget_table
      assert_no_match 'column7', compiled_widget_table
    end

    test "iterates over collection setting table row id correctly" do
      assert_match 'widget:298486374', compiled_widget_table
      assert_match 'widget:980190962', compiled_widget_table
    end

    test "renders cell contents" do
      assert_match '<td class="column2">Hammer</td>', compiled_widget_table
    end

    # this behavior could change after we implement support for decorators
    # test "truncates cell values by default" do
    #   assert_match /\{\{\(widget.column3\).to_s.truncate\(27\)\}\}/, compiled_widget_table
    # end

    test "table cell shows related item name or display name" do
      # note this will move to a helper that will intelligently look
      # for decorated methods such as name or display_name
      assert_match '<td class="category_id">Toys</td>', compiled_widget_table
      assert_match '<td class="category_id">Tools</td>', compiled_widget_table
    end

    test "table displays only columns specified if columns option provided" do
      compiled = compiled_widget_table(columns: [:column3, :column4])
      assert_match 'column3', compiled
      assert_match 'column3', compiled
      refute_match 'column2', compiled
      refute_match 'category_id', compiled
      refute_match 'column5', compiled
      refute_match 'column6', compiled
    end

    test "table column titles may be customized" do
      compiled = compiled_widget_table(columns: {"Column3 is the Best" => :column3})
      assert_match /<th class="column3">Column3 is the Best/, compiled
    end

    def compiled_widget_table_with_proc_column
      arbre {
         smart_table(:widgets, columns: {
           "This column will error" => -> (widget) { doesnt_work },
           "This column will be fine" => -> (widget) { widget.column2.upcase },
         })
      }
    end

    test "table cell has 'Error' if a value specified as a proc throws an exception" do
      assert_match 'Error', compiled_widget_table_with_proc_column
    end

    test "table cell contains result of proc.call if no exception is raised" do
      assert_match 'LEGO', compiled_widget_table_with_proc_column
    end

    test "table cell class is valid when proc is used" do
      assert_match 'class="this_column_will_error"', compiled_widget_table_with_proc_column
    end

    test "attribute accessor appended with _link generates a link" do
      fragment = arbre {
          smart_table(:widgets, columns: {
              'A link column' => :column3_link
            })
        }
      assert_match /column3.*href="\/widgets\/(\d+)/, fragment
    end

    test "timestamp accessor appeneded with _in_words generates code that uses time_ago_in_words" do
      fragment = arbre {
          smart_table(:widgets, columns: {
              'Created' => :created_at_in_words
            })
        }
      assert_match /class="created_at.*less than a minute ago/, fragment
    end

  end

end
