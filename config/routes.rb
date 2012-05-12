Gistflow::Application.routes.draw do
  match '/auth/github/callback'  => 'users#create'
  match '/auth/twitter/callback' => 'account/twitter#create'
  
  match '/login'  => 'sessions#create' if Rails.env.development?
  match '/logout' => 'sessions#destroy'
  
  match '/flow'      => 'posts#flow'
  match '/all'       => 'posts#all'
  match '/following' => 'posts#following'
  match '/observing' => 'posts#observing'
  match '/bookmarks' => 'bookmarks#index'
  
  get :sitemap, to: 'sitemap#show', as: :xml
  
  namespace :account do
    resources :followings
    resources :bookmarks, only: [:create, :destroy]
    resources :observings, only: [:create, :destroy]
    resources :subscriptions, only: [:index, :create, :destroy]
    resources :likes, only: :create
    resources :notifications, only: :index
    get settings: 'settings#edit', as: :settings
    get profile: 'profiles#edit', as: :profile
  end
  
  resources :posts do
    resources :comments, only: :create, module: :posts do
      post :preview
    end
  end
  
  resource :search, only: :create
  
  get '/empty_search'  => 'searches#empty', as: 'nil_search'
  get '/search/:query' => 'searches#show',  as: 'show_search'
  
  resources :tags, only: :show
  
  resources :users, only: :show do
    scope module: :users do
      resources :followers, only: :index
      resources :followings, only: :index
    end
  end
  
  
  namespace :admin do
    resources :users, only: :index
  end
  
  root to: 'posts#index'
  match '*a', to: 'errors#not_found'
end
