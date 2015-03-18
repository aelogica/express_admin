require 'express_admin/ajax_datatables'
require 'express_admin/menu'
require 'gravatar_image_tag'
require 'sass-rails'
require 'recursive-open-struct'
require 'select2-rails'
require 'ostruct'
require 'underscore-rails'
require 'underscore-string-rails'
require 'kaminari'
require 'foundation-rails'

def gem_path(gem)
  Gem::Specification.find_by_name(gem).gem_dir
end

def stylesheets_path(gem)
  File.join(gem_path(gem), 'app', 'assets', 'stylesheets')
end

module ExpressAdmin
  class Engine < ::Rails::Engine
    isolate_namespace ExpressAdmin
    include ExpressAdmin::Menu::Loader

    initializer "bourbon" do
      Sass.load_paths << stylesheets_path("bourbon")
    end

    initializer :assets do |config|
      engine_assets_path = File.join(File.dirname(__FILE__), '..', '..', 'app', 'assets')
      all_assets = Dir.glob File.join(engine_assets_path, 'stylesheets', '**', '*.css*')
      all_assets += Dir.glob File.join(engine_assets_path, 'javascripts', '**', '*.js*')
      all_assets.each {|path| path.gsub!("#{engine_assets_path}/stylesheets/", '')}
      all_assets.each {|path| path.gsub!("#{engine_assets_path}/javascripts/", '')}
      all_assets.each {|path| path.gsub!("#{engine_assets_path}/fonts/", '')}
      all_assets.each {|path| path.gsub!(/.(scss|coffee)$/, '')}

      Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
      Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
      Rails.application.config.assets.precompile += all_assets
      Rails.application.config.assets.precompile += %w( express_admin/sections/_header.css )
      Rails.application.config.assets.precompile += %w( express_admin/shared/_navigation.css )

      ExpressAdmin::Engine.all_rails_engines.each do |engine|
        if engine.methods.include?(:additional_assets)
          puts "#{engine.to_s}: additional_assets #{engine.additional_assets.inspect}"
          Rails.application.config.assets.precompile += engine.additional_assets
        end
      end
    end

    initializer 'express_admin.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper ExpressAdmin::ModuleSettingsHelper
      end
    end

    config.autoload_paths += Dir[ExpressAdmin::Engine.root.join('app', 'jobs')]

    config.admin_mount_point = '/admin'

    def all_rails_engines
      Rails.application.eager_load!
      @all_engines ||= ::Rails::Engine.descendants
    end

    # Find all the rails engines that have
    # :addon_name presumably from including
    # ExpressAdmin::Menu::Loader
    def all_addons
      @all_addons ||= all_rails_engines.select do |engine|
        engine.methods.include?(:addon_name)
      end
    end

  end
end
