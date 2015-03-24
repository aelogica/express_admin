require 'test_helper'

module ExpressAdmin

  class MenuTest < ActiveSupport::TestCase
    # test "Menu.[] accepts module name and returns the module's menu" do
    #   menu = ExpressAdmin::Menu['express_admin']
    #   assert_equal 'Dashboard', menu.title
    # end

    test "Menu.from() accepts path and returns a menu from the yaml" do
      menu = ExpressAdmin::Menu.from 'test/fixtures/express_admin/test_menu.yml'
      assert_equal 'Big Menu', menu.title
      assert_equal 3, menu.items.size
      assert_equal 'express_admin.baz_path', menu.items.last.path
    end
  end
end
