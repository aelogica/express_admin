$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'express_admin/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'express_admin'
  s.version     = ExpressAdmin::VERSION
  s.authors     = ['Steven Talcott Smith']
  s.email       = ['steve@aelogica.com']
  s.homepage    = 'https://rubygems.org/gems/express_admin'
  s.summary     = 'ExpressAdmin provides an admin menu framework based on Foundation.'
  s.description = 'ExpressAdmin is the admin menu framework used by appexpress.io, ExpressBlog, etc.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib,vendor}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir["test/**/*"] - Dir["test/log/*", "test/tmp/*", "test/dummy/tmp/**/*", "test/dummy/log/*"]

  s.add_dependency 'bourbon', '~> 3.2'
  s.add_dependency 'express_templates', '~> 0.11'
  s.add_dependency 'jquery-rails', '~> 4.0'
  s.add_dependency 'foundation_apps_styles', '~> 1.1', '>= 1.1.0'
  s.add_dependency 'tinymce-rails', '~> 4.1', '>= 4.1.6'
  s.add_dependency 'request_store', '~> 1.2'

  s.add_dependency 'gravatar_image_tag', '~> 1.2'
  s.add_dependency 'kaminari'
  s.add_dependency 'rails', '~> 4.2', '>= 4.2.1'
  s.add_dependency 'responders', '~> 2.1'
  s.add_dependency 'select2-rails', '>= 3.5'
  s.add_dependency 'jquery-ui-rails'
  s.add_dependency 'coffee-script', '~> 2.4'
  s.add_dependency 'dropzonejs-rails'
  s.add_dependency 'countries'
  s.add_dependency 'jquery-validation-rails'

  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'pry', '~> 0'
  s.add_development_dependency "binding_of_caller", "~> 0.7"
  s.add_development_dependency "pry-stack_explorer", "~> 0.4"
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'minitest-rails-capybara', '~> 2.1'
  s.add_development_dependency 'minitest-rg', '~> 5.1'
  s.add_development_dependency 'minitest-line', '~> 0'
end
