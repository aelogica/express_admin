require 'express_admin'
module DummyEngine
  class Engine < ::Rails::Engine
    initializer :assets do |config|
      engine_assets_path = File.join(File.dirname(__FILE__), '..', '..', 'app', 'assets')
      all_assets = Dir.glob File.join(engine_assets_path, 'stylesheets', '**', '*.css*')
      all_assets += Dir.glob File.join(engine_assets_path, 'javascripts', '**', '*.js*')
      all_assets.each {|path| path.gsub!("#{engine_assets_path}/stylesheets/", '')}
      all_assets.each {|path| path.gsub!("#{engine_assets_path}/javascripts/", '')}
      Rails.application.config.assets.precompile += all_assets
    end
    include ::ExpressAdmin::Menu::Loader
    DummyEngine::Engine.config.dummy_engine_mount_point = '/'
    isolate_namespace DummyEngine
  end
end
