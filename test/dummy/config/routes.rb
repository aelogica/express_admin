Rails.application.routes.draw do

  get 'demo/show'
  get 'demo/sign_in'

  mount ExpressAdmin::Engine => "/admin"
end
