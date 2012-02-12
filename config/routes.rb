Gistflow::Application.routes.draw do
  match '/auth/:provider/callback' => 'users#create'
  match '/login' => 'sessions#create' if Rails.env.development?
  match '/logout' => 'sessions#destroy'
  match '/search' => 'posts#search'
  
  resources :posts do
    match :like, :on => :member, :via => :post
    match :add_to_favorites, :on => :member, :via => :post
    resources :comments, :only => :create
    
    collection do
      resources :articles, {
        :only => [:index, :show],
        :controller => :posts, 
        :type => 'Post::Article'
      }
      resources :questions, {
        :only => [:index, :show], 
        :controller => :posts, 
        :type => 'Post::Question'
      }
      resources :community, {
        :only => [:index, :show], 
        :controller => :posts, 
        :type => 'Post::Community'
      }
    end
  end
  
  resources :tags, :only => :show
  
  resources :notifications, :only => :index
  
  resources :subscriptions, :only => [:create, :destroy]
  resources :users, :only => :show
  resources :gists, :only => [:show, :index]
  resources :tags, :only => :show
  
  root to: 'posts#index'
end
