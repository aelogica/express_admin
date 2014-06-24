module ExpressAdmin
  class ApplicationController < ActionController::Base
    def redirect_to_oauth
      redirect_to Rails.application.routes.url_helpers.user_omniauth_authorize_path(:appexpress) unless user_signed_in?
    end
    helper_method :redirect_to_oauth
  end
end
