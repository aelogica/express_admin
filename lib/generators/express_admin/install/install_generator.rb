class ExpressAdmin::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  desc "mount express_admin engine; migrate database"
  def install
    route_code = %Q{
  mount ExpressAdmin::Engine, at: ExpressAdmin::Engine.config.admin_mount_point\n}
    inject_into_file "#{Rails.root}/config/routes.rb", route_code, after: "Rails.application.routes.draw do\n"

    git add: "config/routes.rb"
    git commit: "'-m [express_admin] install express_admin'"

    rails_admin_gem_line = <<-EXPRESS_RAILS_ADMIN
  gem 'rails_admin', github: 'aelogica/express_rails_admin'
EXPRESS_RAILS_ADMIN
    inject_into_file "Gemfile", rails_admin_gem_line, after: "group :app_express do\n"

    express_taxonomy_gem_line = <<-EXPRESS_TAXONOMY
  gem "express_taxonomy", git: "https://3d6f43b539ef683a7f390fc3010b51cffbc9ac25:x-oauth-basic@github.com/aelogica/express_taxonomy", branch: "master"
EXPRESS_TAXONOMY
    inject_into_file "Gemfile", express_taxonomy_gem_line, after: "group :app_express do\n"

    Bundler.clean_system("bundle install")
    Bundler.clean_system("rails generate rails_admin:install admin/manage")
    Bundler.clean_system("rake express_admin:install:migrations")
    Bundler.clean_system("rake express_taxonomy:install:migrations")
    Bundler.clean_system("rake db:migrate")
    git add: "."
    git commit: "-m '[express_admin] install express_rails_admin'"
  end


end
