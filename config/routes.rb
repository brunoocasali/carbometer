Carbometer::Application.routes.draw do

  resource :dashboard
  resources :parts, only: [:index, :show]
  resources :posts, only: [:index] do
    collection do
      get :sources
    end
  end
  root to: 'content#home'

end
