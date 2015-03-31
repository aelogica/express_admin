class DummyEngine::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  desc "mount dummy_engine engine"
  def install
    route "mount DummyEngine::Engine, at: DummyEngine::Engine.config.dummy_engine_mount_point"
    rake "dummy_engine:install:migrations"
  end

end
