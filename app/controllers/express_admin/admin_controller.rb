require_dependency "express_admin/application_controller"

module ExpressAdmin
  class AdminController < ApplicationController
    before_filter :authenticate_user!

    layout "express_admin/admin"
  end
end
