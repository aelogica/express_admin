require 'test_helper'
require 'generators/express_admin/module_installer/module_installer_generator'

class ExpressAdmin::Generators::ModuleInstallerGeneratorTest < Rails::Generators::TestCase
  destination File.expand_path("../../../tmp", File.dirname(__FILE__))
  setup :prepare_destination

  tests ExpressAdmin::Generators::ModuleInstallerGenerator

  def test_common_files_on_invoke
    run_generator

    assert_file 'app/assets/javascripts/tmp/admin/ajax_forms.js'
  end

  def test_installer_file_on_invoke
    run_generator

    assert_file 'lib/generators/tmp/install/install_generator.rb'
    assert_file 'lib/generators/tmp/install/USAGE'
    assert_directory 'lib/generators/tmp/install/templates'
    assert_file 'test/lib/generators/tmp/install/install_generator_test.rb'
  end

  def test_common_files_on_revoke
    run_generator [], behavior: :revoke

    assert_no_file 'app/assets/javascripts/tmp/admin/ajax_forms.js'
  end
end
