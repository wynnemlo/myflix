Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'

  # Home page
  get '/home', to: 'videos#index'

  # Videos and reviews
  resources :videos, only: [:index, :show] do
    collection do
      get 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  # Video categories
  resources :categories, only: [:show]

  # Users
  resources :users, only: [:create, :show]

  # User Invitations
  resources :invitations, only: [:new, :create]

  # Password retrieval
  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'password_resets#expired_token'

  # Video queue
  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: "queue_items#update_queue"
  get 'my_queue', to: 'queue_items#index'

  # Followers
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:destroy, :create]

  # Login / Logout
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  get '/log_out', to: 'sessions#destroy'
  get '/register', to: 'users#new'


end
