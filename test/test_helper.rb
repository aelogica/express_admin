# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "minitest/rails/capybara"
require 'minitest/rg'


Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

if ActiveSupport::TestCase.respond_to?(:fixture_path=)
 ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
 ActiveSupport::TestCase.fixtures :all
end

Rails.application.load_generators
