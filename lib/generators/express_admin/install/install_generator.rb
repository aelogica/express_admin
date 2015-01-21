class ExpressAdmin::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  desc "mount express_admin engine; migrate database"
  def install
    route_code = %Q{
  mount ExpressAdmin::Engine, at: ExpressAdmin::Engine.config.admin_mount_point\n}
    inject_into_file "#{Rails.root}/config/routes.rb", route_code, after: "Rails.application.routes.draw do\n"

    rails_admin_gem_line = <<-EXPRESS_RAILS_ADMIN
  gem 'rails_admin', github: 'aelogica/express_rails_admin'
EXPRESS_RAILS_ADMIN
    inject_into_file "Gemfile", rails_admin_gem_line, after: "group :app_express do\n"

    Bundler.clean_system("bundle install")
    Bundler.clean_system("rails generate rails_admin:install admin/manage")
    Bundler.clean_system("rake express_admin:install:migrations")
    Bundler.clean_system("rake db:migrate")
  end

end
