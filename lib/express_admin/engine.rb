require 'haml-rails'
require 'ostruct'
require 'select2-rails'
require 'underscore-rails'
require 'underscore-string-rails'
require 'message_bus'
require 'gravatar_image_tag'
require 'sass-rails'
require 'recursive-open-struct'

def gem_path(gem)
  Gem::Specification.find_by_name(gem).gem_dir
end

def stylesheets_path(gem)
  File.join(gem_path(gem), 'app', 'assets', 'stylesheets')
end

module ExpressAdmin
  class Engine < ::Rails::Engine
    isolate_namespace ExpressAdmin

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
      Rails.application.config.assets.precompile += %w( message-bus.js )

      ExpressAdmin::Engine.all_rails_engines.each do |engine|
        if engine.methods.include?(:additional_assets)
          puts "#{engine.to_s}: additional_assets #{engine.additional_assets.inspect}"
          Rails.application.config.assets.precompile += engine.additional_assets
        end
      end
    end

    config.autoload_paths += Dir[ExpressAdmin::Engine.root.join('app', 'jobs')]

    config.admin_mount_point = '/admin'

    def all_rails_engines
      Rails.application.eager_load!
      ::Rails::Engine.descendants
    end

  end
end
