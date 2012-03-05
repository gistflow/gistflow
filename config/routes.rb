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
      get :articles
      get :questions
      get :community
    end
    resources :comments, :only => :create
  end
  
  resources :tags, :users, :only => :show
  resources :notifications, :only => :index
  resources :subscriptions, :only => [:create, :destroy]
  resources :gists, :only => [:show, :index]
  
  root to: 'posts#index'
end
