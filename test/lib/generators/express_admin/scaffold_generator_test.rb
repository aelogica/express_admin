require 'test_helper'
require 'generators/express_admin/scaffold/scaffold_generator'

class ExpressAdmin::Generators::ScaffoldGeneratorTest < Rails::Generators::TestCase
  destination File.expand_path("../../../tmp", File.dirname(__FILE__))
  setup :prepare_destination
  setup :copy_routes

  tests ExpressAdmin::Generators::ScaffoldGenerator
  arguments %w(agent first_name:string last_name:string age:integer address:integer)

  def test_scaffold_on_invoke
    run_generator

    # Model
    assert_file "app/models/dummy/agent.rb", /module Dummy\n  class Agent < ActiveRecord::Base/

    # View
    assert_file "app/views/dummy/admin/agents/index.html.et"

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

    # Routes
    assert_file "config/routes.rb" do |content|
      assert_match(/scope 'dummy', as: 'dummy'/, content)
      assert_match(/resources :agents/, content)
    end
  end

  def test_scaffold_on_revoke
    run_generator ["Agent"], behavior: :revoke

    # Model
    assert_no_file "app/models/dummy/agent.rb"

    # View
    assert_no_file "app/views/dummy/admin/agents/index.html.et"

    # Controller
    assert_no_file "app/controllers/dummy/admin/agents_controller.rb"

    # Route
    assert_file "config/routes.rb" do |route|
      assert_no_match(/resources :agents$/, route)
    end
  end
end
