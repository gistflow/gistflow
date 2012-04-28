Gistflow::Application.routes.draw do
  match '/auth/github/callback' => 'users#create'
  match '/auth/twitter/callback' => 'account/twitter#create'
  match '/login' => 'sessions#create' if Rails.env.development?
  match '/logout' => 'sessions#destroy'
  match '/flow' => 'posts#flow'
  match '/all' => 'posts#all'
  
  get :sitemap, :to => 'sitemap#show', :as => :xml
  
  resources :posts do
    member do
      post :like, :memorize
      delete :forgot
    end
    resources :comments, :only => :create, :controller => :comments do
      member do
        get :preview
      end
    end
  end
  
  resource :search, :only => :create
  get '/empty_search' => 'searches#empty', :as => 'nil_search'
  get '/search/:query' => 'searches#show', :as => 'show_search'
  resources :tags, :only => :show
  resources :users, :only => :show
  
  namespace :admin do
    resources :users, :only => [:index]
  end
  
  namespace :account do
    resources :subscriptions, :only => [:index, :create, :destroy]
    resource :remembrance, :only => :show
    resources :gists, :only => :index
    resources :notifications, :only => :index
  end
  resources :gists, :only => :show
  
  root to: 'posts#index'
  match '*a', :to => 'errors#not_found'
end
