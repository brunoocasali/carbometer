Carbometer::Application.routes.draw do
  resource :dashboard
  resources :parts, only: [:index, :show]
  resources :posts, only: [:index] do
    collection do
      get :sources
      get :popular
    end
  end

  resources :contributions, only: :index

  root to: 'content#home'
end
