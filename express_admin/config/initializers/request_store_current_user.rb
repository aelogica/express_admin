class ApplicationController < ActionController::Base

  if defined? Devise
    before_filter do
      RequestStore[:current_user] = current_user
    end
  end

end