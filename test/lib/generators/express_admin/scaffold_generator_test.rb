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

    # Datatables JavaScript
    assert_file "app/assets/javascripts/dummy/admin/agents.js" do |content|
      assert_match /#agents-datatable/, content
      assert_match /first_name/, content
      assert_match /last_name/, content
      assert_match /age/, content
      assert_match /address/, content
      assert_match /#agents-datatable tbody/, content
      assert_match /\$\('#agents-datatable'\)\.data\('source'\)/, content
      assert_match /\$\('#agents-datatable tbody'\)\.removeAttr\('style'\)/, content
    end

    # Datatables Ruby
    assert_file "app/datatables/dummy/agent_datatable.rb" do |content|
      assert_match /class Dummy::AgentDatatable/, content
      assert_match /:admin_dummy_agent_path/, content
      assert_match /:edit_admin_dummy_agent_path/, content

      assert_instance_method :sortable_columns, content do |m|
        assert_match /dummy_agents\.first_name/, m
        assert_match /dummy_agents\.last_name/, m
        assert_match /dummy_agents\.age/, m
        assert_match /dummy_agents\.address'/, m
      end

      assert_instance_method :searchable_columns, content do |m|
        assert_match /dummy\/agents\.first_name/, m
        assert_match /dummy\/agents\.last_name/, m
        assert_match /dummy\/agents\.age'/, m
        assert_match /dummy\/agents\.address'/, m
      end

      # Private data method
      assert_instance_method :data, content do |m|
        assert_match /link_to\(record\.first_name, admin_dummy_agent_path\(record\.id\)/, m
        assert_match /record\.last_name/, m
        assert_match /record\.age/, m
        assert_match /record\.address/, m
      end

      assert_instance_method :get_raw_records, content do |m|
        assert_match /Dummy::Agent\.all/, m
      end

      assert_match "admin_dummy_agent_path(record.id), onClick: 'return false;'", content
      assert_match /confirm: 'Delete this agent permanently\?'/, content
    end

    # Controller
    assert_file "app/controllers/dummy/admin/agents_controller.rb" do |content|
      assert_match(/class Dummy::Admin::AgentsController < ExpressAdmin::AdminController/, content)

      assert_instance_method :index, content do |m|
        assert_match /\@agent = Dummy::Agent\.new/, m
        assert_match /AgentDatatable\.new\(view_context\)/, m
      end

      assert_instance_method :create, content do |m|
        assert_match /@agent = Dummy::Agent\.create\(agent_params\)/, m
        assert_match /render json: {agent: @agent, status: :created}/, m
      end

      assert_instance_method :show, content do |m|
        assert_match /@agent = Dummy::Agent\.find_by_id\(params\[:id\]\)/, m
        assert_match /@agent/, m
        assert_match /agent: @agent, status: :ok/, m
      end

      assert_instance_method :update, content do |m|
        assert_match /@agent = Dummy::Agent\.find_by_id\(params\[:id\]\)/, m
        assert_match /@agent\.update_attributes\(agent_params\)/, m
      end

      assert_instance_method :destroy, content do |m|
        assert_match /@agent = Dummy::Agent\.find_by_id\(params\[:id\]\)/, m
        assert_match /@agent\.destroy/, m
      end

      assert_instance_method :agent_params, content do |m|
        assert_match /params\.require\(:agent\)\.permit!/, m
      end
    end

    # Routes
    assert_file "config/routes.rb" do |content|
      assert_match(/scope 'dummy', as: 'dummy'/, content)
      assert_match(/resources :agents/, content)
    end
  end

  def test_scaffold_on_revoke
    run_generator ["Agent"], behavior: :revoke

    assert_no_file "app/views/dummy/admin/agents/index.html.et"
    assert_no_file "app/controllers/dummy/admin/agents_controller.rb"
  end
end
