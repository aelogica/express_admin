class ExpressAdmin::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  desc "mount express_admin engine; migrate database"
  def install
    route_code = %Q{
    mount ExpressAdmin::Engine, at: ExpressAdmin::Engine.config.admin_mount_point\n}
    inject_into_file "#{Rails.root}/config/routes.rb", route_code, after: "Rails.application.routes.draw do\n"

    git add: "config/routes.rb"
    git commit: "'-m [express_admin] install express_admin'"
  end

end
