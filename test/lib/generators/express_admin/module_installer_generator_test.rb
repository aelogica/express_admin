require 'test_helper'
require 'generators/express_admin/module_installer/module_installer_generator'

class ExpressAdmin::Generators::ModuleInstallerGeneratorTest < Rails::Generators::TestCase
  destination File.expand_path("../../../tmp", File.dirname(__FILE__))
  setup :prepare_destination

  tests ExpressAdmin::Generators::ModuleInstallerGenerator

  def test_common_files_on_invoke
    puts run_generator

    assert_file 'app/assets/javascripts/tmp/admin/ajax_forms.js'
  end

  def test_common_files_on_revoke
    run_generator [], behavior: :revoke

    assert_no_file 'app/assets/javascripts/tmp/admin/ajax_forms.js'
  end
end
