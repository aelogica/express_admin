class DemoController < ApplicationController
  def show
  end

  def sign_in
    render layout: 'express_admin/external'
  end
end
