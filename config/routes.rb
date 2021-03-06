require 'sidekiq/web'
# Authentication for Sidekiq
Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
end if Rails.env.production?

Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'

  # Sidekiq monitor panel
  mount Sidekiq::Web, at: '/sidekiq'

  # Home page
  get 'home', to: 'videos#index'

  # Videos and reviews
  resources :videos, only: [:index, :show] do
    collection do
      get 'search', to: 'videos#search'
      get 'advanced_search', to: 'videos#advanced_search', as: :advanced_search
    end
    resources :reviews, only: [:create]
  end

  # Admin
  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end

  # Video categories
  resources :categories, only: [:show]

  # Users
  resources :users, only: [:create, :show]

  # User Invitations
  resources :invitations, only: [:new, :create]
  get 'expired_token', to: 'pages#expired_token'

  # Password retrieval
  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :password_resets, only: [:show, :create]

  # Video queue
  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: "queue_items#update_queue"
  get 'my_queue', to: 'queue_items#index'

  # Followers
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:destroy, :create]

  # Login / Logout
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'
  get 'log_out', to: 'sessions#destroy'
  get 'register', to: 'users#new'
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'

  mount StripeEvent::Engine, at: '/stripe_events'

end
