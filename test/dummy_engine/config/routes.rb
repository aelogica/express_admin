DummyEngine::Engine.routes.draw do
  namespace :admin do
    scope 'dummy_engine' do
      resources :agents
    end
  end
end
