Rails.application.routes.draw do

  namespace :admin do
    resources :categories do
      resources :widgets do
        resources :parts
      end
    end

    resources :widgets
  end

  get 'demo/show'
  get 'demo/sign_in'

  mount ExpressAdmin::Engine => "/admin"
end
