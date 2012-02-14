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
    collection do
      post :search
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
    resources :comments, :only => :create
  end
  
  resources :tags, :users, :only => :show
  resources :notifications, :only => :index
  resources :subscriptions, :only => [:create, :destroy]
  resources :gists, :only => [:show, :index]
  
  root to: 'posts#index'
end
