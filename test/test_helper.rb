# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../../test/dummy/config/environment.rb",  __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)

require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"
require 'minitest/rg'


# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

if ActiveSupport::TestCase.respond_to?(:fixture_path=)
 ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
 ActiveSupport::TestCase.fixtures :all
end

Rails.application.load_generators

module ExampleEngine
  class Widget < ::Widget ; end
end
