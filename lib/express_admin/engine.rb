require 'haml-rails'
require 'ostruct'
require 'select2-rails'
require 'underscore-rails'
require 'underscore-string-rails'

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

      if Kernel.const_defined?('AppExpress::Engine')
        Rails.application.config.assets.precompile += %w( message-bus.js )
      end
      if Kernel.const_defined?('ExpressBlog::Engine')
        Rails.application.config.assets.precompile += %w( tinymce-jquery.js )
      end
    end

    config.autoload_paths += Dir[ExpressAdmin::Engine.root.join('app', 'jobs')]

    config.admin_mount_point = '/admin'

  end
end
