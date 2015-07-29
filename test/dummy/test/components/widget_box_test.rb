require 'test_helper'

module ExpressAdmin

  class WidgetBoxTest < ActiveSupport::TestCase

    def helpers
      mock_action_view(assigns)
    end

    def assigns
      {resource: Widget.first}
    end

    def rendered_widget_box(*args)
      arbre {
        widget_box(:test, *args)
      }
    end

    test "renders correct widget box title" do
      assert_match /<header class="title">Edit Test/, rendered_widget_box
    end

    test "renders correct widget box title with param" do
      assert_match /<header class="title">Widget Box/, rendered_widget_box(title: "Widget Box")
    end

  end
end