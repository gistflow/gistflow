Gistflow::Application.routes.draw do
  match '/auth/:provider/callback' => 'users#create'
  match '/login' => 'sessions#create' if Rails.env.development?
  match '/logout' => 'sessions#destroy'
  
  resources :posts do
    member do
      post :like
      post :memorize
      delete :forgot
    end
    resources :comments, :only => :create, :controller => :comments
  end
  
  resource :search, :only => :create
  get '/empty_search' => 'searches#empty', :as => 'nil_search'
  get '/search/:query' => 'searches#show', :as => 'show_search'
  resources :tags, :only => :show
  resources :users, :only => :show
  
  namespace :account do
    resources :subscriptions, :only => [:index, :create, :destroy]
    resource :remembrance, :only => :show
    resources :gists, :only => :index
  end
  resources :notifications, :only => :index
  resources :gists, :only => :show
  
  root to: 'home#index'
  match '*a', :to => 'errors#not_found'
end
