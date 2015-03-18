class ExpressAdmin::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  desc "mount express_admin engine"
  def install
    route "mount ExpressAdmin::Engine, at: ExpressAdmin::Engine.config.admin_mount_point"
    rake "express_admin:install:migrations"
  end

end
