require 'test_helper'
require 'generators/express_admin/scaffold/scaffold_generator'
require 'generators_test_helper'

class ExpressAdmin::Generators::ScaffoldGeneratorTest < Rails::Generators::TestCase
  include GeneratorsTestHelper
  setup :copy_routes

  tests ExpressAdmin::Generators::ScaffoldGenerator
  arguments %w(agent first_name:string last_name:string age:integer address:integer)

  def test_scaffold_on_invoke
    run_generator

    assert_file "app/models/agent.rb", /^class Agent < ActiveRecord::Base/

    # TODO:
    assert_migration "db/migrate/create_agents.rb"

    # View
    assert_file "app/views/admin/agents/index.html.et"

    # Controller
    assert_file "app/controllers/admin/agents_controller.rb" do |content|
      assert_match(/module Admin/, content)
      assert_match(/class AgentsController < AdminController/, content)

      assert_match(/defaults resource_class: Agent/, content)
      assert_match(/def agent_params()/, content)
    end

    # Routes
    assert_file "config/routes.rb" do |content|
      assert_match(/Dummy::Engine.routes.draw/, content)
      assert_match(/namespace :admin do/, content)
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
      assert_no_match(/resources :agents/, route)
    end
  end

  def test_scaffold_twice
    run_generator ["blog", "title: string"]
    run_generator ["picture", "url: string"]

    assert_file "config/routes.rb" do |content|
      assert_match(/resources :blogs/, content)
      assert_match(/resources :pictures/, content)
    end
  end
end
