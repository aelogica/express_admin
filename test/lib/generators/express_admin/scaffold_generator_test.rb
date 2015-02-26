require 'test_helper'
require 'generators/express_admin/scaffold/scaffold_generator'

class ExpressAdmin::Generators::ScaffoldGeneratorTest < Rails::Generators::TestCase
  destination File.expand_path("../../../tmp", File.dirname(__FILE__))
  setup :prepare_destination

  tests ExpressAdmin::Generators::ScaffoldGenerator
  arguments %w(agent first_name:string last_name:string age:integer address:integer)

  def test_scaffold_on_invoke
    run_generator

    assert_file "app/views/dummy/admin/agents/index.html.et"
  end

  def test_scaffold_on_revoke
    run_generator ["Agent"], behavior: :revoke

    assert_no_file "app/views/dummy/admin/agents/index.html.et"
  end
end
