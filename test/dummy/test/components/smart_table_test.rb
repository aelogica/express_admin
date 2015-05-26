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
    SHOW_ON_CLICK_ATTR = 'data-resource-url=\"{{resource_path(widget.id)}}\"'

    test "does not include show_on_click js handler by default" do
      assert_no_match SHOW_ON_CLICK_JS, compiled_widget_table
    end

    test "show_on_click option adds some javascript and attrs" do
      assert_match SHOW_ON_CLICK_JS, compiled_widget_table(show_on_click: true)
      assert_match SHOW_ON_CLICK_ATTR, compiled_widget_table
    end

    test "resource_link option respected" do
      assert_match 'data-resource-url=\"{{other_path_helper}}\"', 
                    compiled_widget_table(resource_link: "{{other_path_helper}}")
    end

  end

end
