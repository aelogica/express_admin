require 'test_helper'

module ExpressAdmin

  class WidgetBoxTest < ActiveSupport::TestCase

    def helpers
      mock_action_view
    end

    def assigns
      {category: Category.first}
    end

    def rendered_widget_box(*args)
      arbre {
        widget_box(:category, *args)
      }
    end

    test "renders correct widget box title" do
      assert_match /<header class="title">Edit Category/, rendered_widget_box
    end

    test "renders correct widget box title with param" do
      assert_match /<header class="title">Category Box/, rendered_widget_box(title: "Category Box")
    end

  end
end