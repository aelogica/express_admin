require 'express_admin/menu'
require 'express_admin/version'
require 'express_admin/standard_actions'
require 'express_templates'
require 'jquery-rails'
require 'select2-rails'
require 'foundation_apps_styles'
require 'bourbon'
require 'gravatar_image_tag'
require 'kaminari'
require 'responders'
require 'tinymce-rails'

require File.join(File.dirname(__FILE__), '..', '..', 'app', 'components', 'express_admin', 'definition_list')

# should be a way to add this folder to rails' autoload paths
components = Dir.glob(File.join(File.dirname(__FILE__), '..', '..', 'app', 'components', '**', '*.rb'))
components.sort!
components.each {|component| require component }

module ExpressAdmin
  class Engine < ::Rails::Engine

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
    Rails.application.config.assets.precompile << /\.(?:png)$/
    Rails.application.config.assets.precompile += all_assets
  end

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

  class Railtie < ::Rails::Railtie
    config.app_generators.template_engine :et
  end
end
