Gistflow::Application.routes.draw do
  match '/auth/github/callback'  => 'users#create'
  match '/auth/twitter/callback' => 'account/twitter#create'
  
  match '/login'  => 'sessions#create' if Rails.env.development?
  match '/logout' => 'sessions#destroy'
  
  match '/flow' => 'posts#flow'
  match '/all'  => 'posts#all'
  
  get :sitemap, to: 'sitemap#show', as: :xml
  
  resources :posts do
    member do
      post :like, :memorize
      delete :forgot
    end
    resources :comments, only: :create, controller: :comments do
      get :preview, as: :member
    end
  end
  
  resource :search, :only => :create
  get '/empty_search' => 'searches#empty', :as => 'nil_search'
  get '/search/:query' => 'searches#show', :as => 'show_search'
  resources :tags, :only => :show
  resources :users, :only => :show do
    member do
      delete :unfollow
      post :follow
      get :following, :followers
    end
  end
  
  namespace :admin do
    resources :users, only: :index
  end
  
  namespace :account do
    resource :remembrance, only: :show
    resources :gists, :notifications, only: :index
    resources :subscriptions, only: [:index, :create, :destroy]
    resources :observings, only: [:create, :destroy]
  end
  
  root to: 'posts#index'
  
  match '*a', to: 'errors#not_found'
end
