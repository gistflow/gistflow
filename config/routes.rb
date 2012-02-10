Gistflow::Application.routes.draw do
  match '/auth/:provider/callback' => 'users#create'
  match '/login' => 'sessions#create' if Rails.env.development?
  match '/logout' => 'sessions#destroy'
  
  resources :posts do
    match :like, :on => :member, :via => :post
    match :add_to_favorites, :on => :member, :via => :post
    resources :comments, :only => :create
  end
  
  resources :tags, :only => :show
  
  resources :notifications, :only => :index
  
  resources :subscriptions, :only => [:create, :destroy]
  resources :users, :only => :show
  resources :gists, :only => [:show, :index]
  
  resources :articles, 
    :only => [:index, :show], 
    :controller => :posts, 
    :type => 'Article'
  resources :questions,
    :only => [:index, :show], 
    :controller => :posts, 
    :type => 'Question'
  resources :community, 
    :only => [:index, :show], 
    :controller => :posts, 
    :type => 'Community'
  resources :tags, :only => :show
  root to: 'posts#index'
end
