Rails.application.routes.draw do

  get 'demo/show'

  mount ExpressAdmin::Engine => "/admin"
end
