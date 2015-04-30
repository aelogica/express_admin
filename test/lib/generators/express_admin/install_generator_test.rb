require 'test_helper'
require 'generators/express_admin/install/install_generator'
require 'generators_test_helper'

class ExpressAdmin::Generators::InstallGeneratorTest < Rails::Generators::TestCase
  include GeneratorsTestHelper
  tests ExpressAdmin::Generators::InstallGenerator
  setup :copy_engine

  def test_install_on_invoke
    run_generator

    assert_file 'app/controllers/tmp/admin/admin_controller.rb' do |content|
      assert_match /module Tmp/, content
      assert_match /class AdminController < ApplicationController/, content
      assert_match /before_filter :authenticate_user! if defined\?\(Devise\)/, content
      assert_match /layout "tmp\/admin"/, content
    end

    assert_file 'app/views/layouts/tmp/admin.html.et' do |content|
      assert_match /render\(template: 'layouts\/express_admin\/admin'\)/, content
    end

    assert_file 'lib/generators/tmp/install/install_generator.rb'
    assert_file 'lib/generators/tmp/install/USAGE'
    assert_directory 'lib/generators/tmp/install/templates'
    assert_file 'test/lib/generators/tmp/install/install_generator_test.rb'

    assert_file 'app/assets/javascripts/tmp/admin/application.js' do |content|
      assert_match /\/\/= require_tree \./, content
    end

    assert_file 'app/assets/stylesheets/tmp/admin/application.css' do |content|
      assert_match /\*= require express_admin/, content
    end

    assert_file 'config/menu.yml'

    assert_file 'lib/tmp/engine.rb' do |content|
      assert_match /require \'express_admin\'/, content
      assert_match /Tmp::Engine.config.tmp_mount_point = \'\/\'/, content
      assert_match /include ::ExpressAdmin::Menu::Loader/, content

      assert_match "initializer :assets do |config|", content
      assert_match "engine_assets_path = File.join(File.dirname(__FILE__), '..', '..', 'app', 'assets')", content
      assert_match "all_assets = Dir.glob File.join(engine_assets_path, 'stylesheets', '**', '*.css*')", content
      assert_match "all_assets += Dir.glob File.join(engine_assets_path, 'javascripts', '**', '*.js*')", content
      assert_match 'all_assets.each {|path| path.gsub!("#{engine_assets_path}/stylesheets/", \'\')}', content
      assert_match 'all_assets.each {|path| path.gsub!("#{engine_assets_path}/javascripts/", \'\')}', content
      assert_match "Rails.application.config.assets.precompile += all_assets", content
    end
  end

  def test_install_on_revoke
    run_generator [], behavior: :revoke

    assert_no_file 'app/controllers/tmp/admin_controller.rb'

    assert_no_file 'app/views/layouts/tmp/admin.html.et'

    assert_no_file 'lib/generators/tmp/install/install_generator.rb'
    assert_no_file 'lib/generators/tmp/install/USAGE'
    assert_no_directory 'lib/generators/tmp/install/templates'
    assert_no_file 'test/lib/generators/tmp/install/install_generator_test.rb'

    assert_no_file 'app/assets/javascripts/tmp/admin/application.js'

    assert_no_file 'app/assets/stylesheets/tmp/admin/application.css'

    assert_no_file 'config/menu.yml'
  end
end