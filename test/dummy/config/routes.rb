Rails.application.routes.draw do

  namespace :admin do
    resources :categories
    resources :widgets
  end

  get 'demo/show'
  get 'demo/sign_in'

  mount ExpressAdmin::Engine => "/admin"
end
