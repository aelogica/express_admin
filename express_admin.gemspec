$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "express_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "express_admin"
  s.version     = ExpressAdmin::VERSION
  s.authors     = ["Steven Talcott Smith"]
  s.email       = ["steve@aelogica.com"]
  s.homepage    = ""
  s.summary     = "ExpressAdmin provides an admin menu framework based on foundation."
  s.description = "ExpressAdmin is the admin menu framework used by appexpress.io, ExpressBlog."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.1"

  s.add_dependency "haml-rails"
  s.add_dependency "resque", '1.25.2'
  s.add_dependency "message_bus"
  s.add_development_dependency "foundation-rails", "~> 5.3"
  s.add_development_dependency "jquery-rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry"

end
