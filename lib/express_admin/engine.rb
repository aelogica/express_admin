require 'haml-rails'
require 'ostruct'
module ExpressAdmin
  class Engine < ::Rails::Engine
    isolate_namespace ExpressAdmin

    initializer :assets do |config|
      engine_assets_path = File.join(File.dirname(__FILE__), '..', '..', 'app', 'assets')
      all_assets = Dir.glob File.join(engine_assets_path, 'stylesheets', '**', '*.css*')
      all_assets += Dir.glob File.join(engine_assets_path, 'javascripts', '**', '*.js*')
      all_assets.each {|path| path.gsub!("#{engine_assets_path}/stylesheets/", '')}
      all_assets.each {|path| path.gsub!("#{engine_assets_path}/javascripts/", '')}
      all_assets.each {|path| path.gsub!(/.(scss|coffee)$/, '')}
      Rails.application.config.assets.precompile += all_assets
    end

    config.autoload_paths += Dir[ExpressAdmin::Engine.root.join('app', 'jobs')]

    config.mount_point = '/admin'

    def self.express_admin_menu
      OpenStruct.new(name: 'Admin', items:
        [OpenStruct.new(name: 'Dashboard', path: "express_admin.root_path")])
    end

  end
end
