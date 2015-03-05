require 'test_helper'
require 'generators/express_admin/common_files/common_files_generator'

class ExpressAdmin::Generators::CommonFilesGeneratorTest < Rails::Generators::TestCase
  destination File.expand_path("../../../tmp", File.dirname(__FILE__))
  setup :prepare_destination

  tests ExpressAdmin::Generators::CommonFilesGenerator

  def test_common_files_on_invoke
    run_generator

    assert_file "app/assets/javascripts/tmp/admin/ajax_forms.js"
  end

  def test_common_files_on_revoke
    run_generator [], behavior: :revoke

    assert_no_file "app/assets/javascripts/tmp/admin/ajax_forms.js"
  end
end