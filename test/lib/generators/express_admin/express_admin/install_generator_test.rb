require 'test_helper'
require 'generators/express_admin/install/install_generator'

module ExpressAdmin
  class ExpressAdmin::InstallGeneratorTest < Rails::Generators::TestCase
    tests ExpressAdmin::InstallGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
