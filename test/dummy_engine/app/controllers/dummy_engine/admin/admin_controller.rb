require_dependency "dummy_engine/application_controller"

module DummyEngine
  module Admin
    class AdminController < ApplicationController
      helper ::ExpressAdmin::AdminHelper
      before_filter :authenticate_user! if defined?(Devise)
      layout "dummy_engine/admin"
    end
  end
end