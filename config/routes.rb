Gistflow::Application.routes.draw do
  match '/auth/:provider/callback' => 'users#create'
  match '/login' => 'sessions#create' if Rails.env.development?
  match '/logout' => 'sessions#destroy'
  resources :posts
  resources :users, :only => :show
  resources :articles, :only => :index, :controller => :posts, :type => 'Article'
  resources :questions, :only => :index, :controller => :posts, :type => 'Question'
  resources :comminity, :only => :index, :controller => :posts, :type => 'Community'
  resources :tags, :only => :show
  root to: 'posts#index'
end
