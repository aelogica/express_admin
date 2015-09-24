require 'test_helper'

module Components

  class ModuleSidebarTest < ActiveSupport::TestCase

    class MenuItem
      attr_accessor :title, :path, :items

      def initialize(title, path, items)
        @title = title
        @path = path
        @items = items
      end
    end

    def rendered_module_sidebar
      arbre {
        module_sidebar
      }
    end

    def helpers
      mock_action_view do
        def foo_path ; "foo" ; end
        def bar_path ; "bar" ; end
        def baz_path ; "baz" ; end
        def current_menu
          MenuItem.new('Big Menu', 'menu_path', [
                          MenuItem.new('Foo', 'foo_path',[]),
                          MenuItem.new('Bar', 'bar_path', []),
                          MenuItem.new('Baz', 'baz_path', [])])
        end
        def current_menu_name
          current_menu.title
        end

      end
    end

    test "renders the correct current menu name as sidebar title" do
      assert_match /class="title">Big Menu/, rendered_module_sidebar
    end

    test "evals the correct path" do
      assert_equal "foo", helpers.instance_eval(helpers.current_menu.items.first.path)
    end

  end
end
