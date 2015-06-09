require 'test_helper'

module Components

  class SmartTableTest < ActiveSupport::TestCase

    def compiled_widget_table(*args)
      ExpressAdmin::SmartTable.new(:widgets, *args).compile
    end

    test "renders 5 column headers with wrapping divs" do
      matches = compiled_widget_table.scan /<th class=\\"\w+\\">\s*<div>\s*\w+/
      assert_equal 5, matches.length
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
    test "truncates cell values by default" do
      assert_match /\{\{\(widget.column3\).to_s.truncate\(27\)\}\}/, compiled_widget_table
    end

    SHOW_ON_CLICK_JS = "$(document).on('click', 'tr', function(e){"
    SHOW_ON_CLICK_ATTR = 'data-resource-url=\"{{widget_path(widget.id)}}\"'

    test "does not include show_on_click js handler by default" do
      assert_no_match SHOW_ON_CLICK_JS, compiled_widget_table
    end

    test "show_on_click option adds some javascript and attrs" do
      assert_match SHOW_ON_CLICK_JS, compiled_widget_table(show_on_click: true)
      assert_match SHOW_ON_CLICK_ATTR, compiled_widget_table
    end

    test "resource_path option respected" do
      assert_match 'data-resource-url=\"{{other_path_helper}}\"', 
                    compiled_widget_table(resource_path: "other_path_helper")
    end

    test "namespace option prepends namespace to path helper" do
      assert_match 'data-resource-url=\"{{example_engine.widget_path(widget.id)}}\"',
                    compiled_widget_table(namespace: "example_engine")
    end

    test "table cell shows related item name or display name" do
      # note this will move to a helper that will intelligently look
      # for decorated methods such as name or display_name
      assert_match '{{(widget.category.try(:name) || widget.category.to_s).to_s.truncate(27)}}', compiled_widget_table
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

  end

end
