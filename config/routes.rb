Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'

  get '/home', to: 'videos#index'

  resources :videos, only: [:index, :show] do
    collection do
      get 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  resources :users, only: [:create]

  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  get '/log_out', to: 'sessions#destroy'
  get '/register', to: 'users#new'

  resources :categories, only: [:show]
end
