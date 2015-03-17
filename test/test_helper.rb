# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

Rails.application.load_generators

def copy_routes
  routes = File.join(File.dirname(__FILE__), 'fixtures', 'routes.rb')
  destination = File.join(destination_root, 'config')
  FileUtils.mkdir_p(destination)
  FileUtils.cp File.expand_path(routes), File.expand_path(destination)
end