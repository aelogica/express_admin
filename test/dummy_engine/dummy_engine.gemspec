$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dummy_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dummy_engine"
  s.version     = DummyEngine::VERSION
  s.authors     = ["Nestor G Pestelos Jr"]
  s.email       = ["ngpestelos@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of DummyEngine."
  s.description = "TODO: Description of DummyEngine."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.1"
  s.add_dependency "express_admin", "~> 1.0"

  s.add_development_dependency "sqlite3"
end
