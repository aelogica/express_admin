require 'test_helper'

module ExpressAdmin

  class SmartFormTest < ActiveSupport::TestCase

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
        def widgets_path
          "/widgets"
        end
        alias collection_path widgets_path
        def admin_widgets_path
          "/admin/widgets"
        end
      end
      view
    end

    def widget_form(*args)
      arbre {
        smart_form(:widget, *args)
      }
    end

    test "renders a form correct id" do
      assert_match /form.*id="widget"/, widget_form
    end

    test "uses inherited_resources path helpers to set correct action" do
      action_attrib = 'action="/widgets"'
      assert_match action_attrib, widget_form
    end

    test "action path can be overridden" do
      custom_action = '/something_custom'
      assert_match /action="#{custom_action}"/, widget_form(action: custom_action)
    end

    test "category field is a select" do
      assert_match /<select.*name="widget\[category_id\]".*class="select2"/, widget_form
    end

    test "string field column2 is an input" do
      assert_match /<input.*type="text".*name="widget\[column2\]"/, widget_form
    end

    test "text field column3 is a text_area" do
      assert_match /<textarea.*rows="10".*name="widget\[column3\]"/, widget_form
    end

    test "datetime field column4 is a datetime_field" do
      assert_match /<input.*type="datetime".*name="widget\[column4\]"/, widget_form
    end

    test "boolean field column5 is a checkbox" do
      assert_match /<input.*type="checkbox".*name="widget\[column5\]"/, widget_form
    end

    test "integer column7 is a number_field" do
      assert_match /<input.*type="number".*name="widget\[column7\]"/, widget_form
    end

    test "timestamps are not editable" do
      form_with_timestamps = widget_form(show_timestamps: true)
      assert_match /Created At:.*\n/, form_with_timestamps
      assert_match /Updated At:.*\n/, form_with_timestamps
    end

    test "fields have labels" do
      matches = widget_form.scan /<label.*>/
      assert 7, matches.length

      assert_match '<label for="widget_category_id">Category</label>', widget_form
    end

    test "fields are wrapped in a div" do
      assert_match '<div class="field-wrapper">', widget_form
    end

    test 'path prefix is provided' do
      action_attrib = 'action="/admin/widgets"'
      assert_match action_attrib, widget_form(path_prefix: 'admin')
    end

    test "options for select come from the related collection" do
      assert_match /<option.*>Toys<\/option>/, widget_form
      assert_match /<option.*>Tools<\/option>/, widget_form
    end

    test "options for select work when a namespace is specified" do
      assert_match /<option.*>Toys<\/option>/, widget_form(namespace: "example_engine")
      assert_match /<option.*>Tools<\/option>/, widget_form(namespace: "example_engine")
    end

    test "multiple select is used for has_many_through associations" do
      assert_match /select.*multiple="multiple".*name="widget\[tag_ids\]\[\]"/, widget_form
    end

    test "excluded fields are excluded" do
      refute_match 'column3', widget_form(exclude: [:column3])
    end

    test "virtual attributes may be included" do
      assert_match 'password', widget_form(virtual: [:password])
    end
  end
end
