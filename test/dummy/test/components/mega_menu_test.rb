require 'test_helper'

module ExpressAdmin

  class MegaMenuTest < ActiveSupport::TestCase

    class MenuItem
      attr_accessor :title, :path

      def initialize(title, path)
        @title = title
        @path = path
      end
    end

    def rendered_mega_menu
      arbre {
        mega_menu
      }
    end

    def helpers
      OpenStruct.new(
        admin_menus: [MenuItem.new('Big Menu', 'my_path'), MenuItem.new('Foo', 'another_path')],
        my_path: 'evaled_path',
        another_path: 'some_path'
      )
    end

    test "renders" do
      assert rendered_mega_menu
    end	

    test "links menu to eval'd path" do
      assert_match /href="evaled_path"/, rendered_mega_menu
      assert_match /href="some_path"/, rendered_mega_menu
    end 

    test "replaces whitespace in menu title to underscore for icon class" do
      assert_match /icon-express_big_menu/, rendered_mega_menu
      assert_match /icon-express_foo/, rendered_mega_menu
    end
  end
end

