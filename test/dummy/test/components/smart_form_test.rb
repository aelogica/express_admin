require 'test_helper'

module ExpressAdmin

  class SmartFormTest < ActiveSupport::TestCase
    def compiled_widget_form(*args)
      ExpressAdmin::SmartForm.new(:widget, *args).compile
    end

    test "renders a form correct id" do
      assert_match '<form id=\"widget\"', compiled_widget_form
    end

    test "uses inherited_resources path helpers to set correct action" do
      action_attrib = 'action=\"{{@widget.try(:persisted?) ? widget_path(@widget.id) : widgets_path}}\"'
      assert_match action_attrib, compiled_widget_form
    end

    test "action path can be overridden" do
      custom_action = '{{something_custom}}'
      action_attrib = 'action=\"'+custom_action+'\"'
      assert_match action_attrib, compiled_widget_form(action: custom_action)
    end

    test "category field is a select" do
      assert_match 'select_tag("widget[category_id]"', compiled_widget_form
    end

    test "string field column2 is an input" do
      assert_match 'text_field(:widget, :column2)', compiled_widget_form
    end

    test "text field column3 is a text_area" do
      assert_match 'text_area(:widget, :column3)', compiled_widget_form
    end

    test "datetime field column4 is a datetime_field" do
      assert_match 'datetime_field(:widget, :column4)', compiled_widget_form
    end

    test "boolean field column4 is a checkbox" do
      assert_match 'check_box(:widget, :column5, {}, "1", "0")', compiled_widget_form
    end

    test "integer column is a number_field" do
      assert_match 'number_field(:widget, :column7)', compiled_widget_form
    end

    test "timestamps are not editable" do
      assert_match 'Created At: {{@widget.try(:created_at)}}', compiled_widget_form
      assert_match 'Updated At: {{@widget.try(:updated_at)}}', compiled_widget_form
    end

    test "fields have labels" do
      #%Q({{label_tag(\"widget_category_id\", \"Category\")}})
      matches = compiled_widget_form.scan /label_tag\(\\"\w+\\", \"\w+\"\)/
      assert 7, matches.length

      assert_match '%Q({{label_tag("widget_category_id", "Category")}})', compiled_widget_form
    end

    test "fields are wrapped in a div" do
      assert_match '<div class=\"field-wrapper\">', compiled_widget_form
    end

    test "namespace option prepends namespace to path helper" do
      action_attrib = 'action=\"{{@widget.try(:persisted?) ? example_engine.widget_path(@widget.id) : example_engine.widgets_path}}\"'
      assert_match action_attrib, compiled_widget_form(namespace: "example_engine")
    end

    test 'path prefix is provided' do
      action_attrib = 'action=\"{{@widget.try(:persisted?) ? admin_widget_path(@widget.id) : admin_widgets_path}}\"'
      assert_match action_attrib, compiled_widget_form(path_prefix: 'admin')
    end

    test "options_from_collection_for_select used for the related collection" do
      assert_match 'options_from_collection_for_select(Category.all.select(:id, :name).order(:name)',
                    compiled_widget_form
    end

    test "options_from_collection_for_select use when a namespace is specified" do
      assert_match 'options_from_collection_for_select(ExampleEngine::Category.all.select(:id, :name).order(:name)',
                    compiled_widget_form(namespace: "example_engine")
    end

    test "multi-select with collection_ids is used for has_many_through associations" do
      assert_match /select_tag.*tag_ids.*multiple: true/, compiled_widget_form
    end

    test "excluded fields are excluded" do
      refute_match 'column3', compiled_widget_form(exclude: [:column3])
    end

    test "virtual attributes may be included" do
      assert_match 'password', compiled_widget_form(virtual: [:password])
    end
  end
end
