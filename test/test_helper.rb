# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../../test/dummy/config/environment.rb",  __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)

require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"
require 'minitest/rg'

require 'pry'

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

# this is placed here so we can test form components with
# namespaced modules without adding extra namespaced models
# to our dummy app
module ExampleEngine
  class Widget < ::Widget
    belongs_to :category, class_name: 'ExampleEngine::Category'
  end
  class Category < ::Category
    has_many :widgets, class_name: 'ExampleEngine::Widget'
  end
  class MockRouteProxy
    def method_missing(*args)
      return '/whatever'
    end
  end
end
module AdditionalHelpers

  def protect_against_forgery?
    true
  end

  def form_authenticity_token
    "AUTH_TOKEN"
  end

end

module ActiveSupport
  class TestCase
    def arbre(assigns = {}, &block)
      Arbre::Context.new assigns, helpers, &block
    end
    def mock_action_view(assigns = {})
      controller = ActionView::TestCase::TestController.new
      ActionView::Base.send :include, ActionView::Helpers
      ActionView::Base.send :include, ActionView::Helpers::UrlHelper
      ActionView::Base.send :include, AdditionalHelpers
      view = ActionView::Base.new(ActionController::Base.view_paths, assigns, controller)
      eigenklass = class << view
        self
      end
      assigns.each do |helper_name,value|
        eigenklass.send(:define_method, helper_name) { value }
      end
      view
    end
  end
end
