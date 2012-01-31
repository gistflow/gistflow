Gistflow::Application.routes.draw do
  match '/auth/:provider/callback' => 'users#create'
  match '/login' => 'sessions#create' if Rails.env.development?
  match '/logout' => 'sessions#destroy'
  resources :posts
  resources :users, :only => :show
  resources :articles, :questions, :comminity, :only => :index, :controller => :posts
  resources :tags, :only => :show
  root to: 'posts#index'
end
