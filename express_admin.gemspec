$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'express_admin/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'express_admin'
  s.version     = ExpressAdmin::VERSION
  s.authors     = ['Steven Talcott Smith']
  s.email       = ['steve@aelogica.com']
  s.homepage    = ''
  s.summary     = 'ExpressAdmin provides an admin menu framework based on Foundation.'
  s.description = 'ExpressAdmin is the admin menu framework used by appexpress.io, ExpressBlog, etc.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib,vendor}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'bourbon', '~> 3.2'
  s.add_dependency 'express_templates', '~> 0.4.2'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'foundation_apps_styles', '~> 1.1.0'

  s.add_dependency 'gravatar_image_tag'
  s.add_dependency 'kaminari'
  s.add_dependency 'rails', '~> 4.2'
  s.add_dependency 'turbolinks'
  s.add_dependency 'responders', '~> 2.0'
  s.add_dependency 'inherited_resources', '~> 1.6'
  s.add_dependency 'select2-rails'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'minitest-rails-capybara'
  s.add_development_dependency "minitest-rg"
end
