require_dependency "express_admin/application_controller"

module ExpressAdmin
  class AdminController < ApplicationController
    layout "express_admin/admin"
  end
end
