require 'test_helper'

module Components

  class SmartTableTest < ActiveSupport::TestCase

    fixtures :widgets

    def compiled_widget_table(*args)
      ExpressAdmin::SmartTable.new(:widgets, *args).compile
    end

    test "should have hidden columns" do
      assert_match 'more-columns-indicator', compiled_widget_table
      assert_no_match 'column7', compiled_widget_table
    end

    test "iterates over collection setting local var correctly" do
      assert_match '(@widgets.each_with_index.map do |widget, widget_index|', compiled_widget_table
    end

    test "renders cell contents within a substitution" do
      assert_match /\{\{[^\{\}]*widget.column2[^\{\}]*\}\}/, compiled_widget_table
    end

    # this behavior could change after we implement support for decorators
    # test "truncates cell values by default" do
    #   assert_match /\{\{\(widget.column3\).to_s.truncate\(27\)\}\}/, compiled_widget_table
    # end

    test "table cell shows related item name or display name" do
      # note this will move to a helper that will intelligently look
      # for decorated methods such as name or display_name
      assert_match 'widget.category.try(:name) || widget.category.to_s', compiled_widget_table
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
      assert_match /<th class=\\"column3\\">Column3 is the Best/, compiled
    end

    def widget_table_with_proc_column
      return -> {
         smart_table(:widgets, columns: {
           "This column will error" => -> (widget) { doesnt_work },
           "This column will be fine" => -> (widget) { widget.column2.upcase },
         })
      }
    end

    def compiled_widget_table_with_proc_column
      ExpressTemplates.compile(&widget_table_with_proc_column)
    end


    test "table cell values may be specified as procs" do
      assert_match '-> (widget) { doesnt_work }', compiled_widget_table_with_proc_column
    end

    class DummyView
      def initialize
        @widgets = Widget.all
      end
      def widget_path(*args) ; "does not matter" ; end
      def link_to(*args) ; widget_path(*args) ; end
    end

    test "table cell has 'Error' if a value specified as a proc throws an exception" do
      assert_match 'Error', DummyView.new.instance_eval(compiled_widget_table_with_proc_column)
    end

    test "table cell contains result of proc.call if no exception is raised" do
      assert_match 'LEGO', DummyView.new.instance_eval(compiled_widget_table_with_proc_column)
    end

    test "table cell class is valid when proc is used" do
      assert_match 'class=\"this_column_will_error\"', compiled_widget_table_with_proc_column
    end

    test "attribute accessor appended with _link generates a link" do
      fragment = -> {
          smart_table(:widgets, columns: {
              'A link column' => :column3_link
            })
        }
      assert_match 'link_to widget.column3, widget_path(widget.id)', ExpressTemplates.compile(&fragment)
    end

    test "timestamp accessor appeneded with _in_words generates code that uses time_ago_in_words" do
      fragment = -> {
          smart_table(:widgets, columns: {
              'Created' => :created_at_in_words
            })
        }
      assert_match "\(widget.created_at \? time_ago_in_words\(widget.created_at\)\+' ago' : 'never'\)", ExpressTemplates.compile(&fragment)
    end

  end

end
