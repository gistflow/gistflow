Gistflow::Application.routes.draw do
  match '/auth/github/callback'  => 'users#create'
  match '/auth/twitter/callback' => 'account/twitter#create'
  
  match '/login'  => 'sessions#create' if Rails.env.development?
  match '/logout' => 'sessions#destroy'
  
  match '/flow'      => 'posts#flow'
  match '/all'       => 'posts#all'
  match '/following' => 'posts#following'
  match '/observing' => 'posts#observing'
  match '/bookmarks' => 'posts#bookmarks'
  
  get :sitemap, to: 'sitemap#show', as: :xml
  
  namespace :account do
    resources :followings
    resources :bookmarks, only: [:create, :destroy]
    resources :observings, only: [:create, :destroy]
    resources :subscriptions, only: [:index, :create, :destroy]
    resources :likes, only: :create
    resources :notifications, only: :index
    resource :settings, :only => [:show, :update]
    resource :profile, :only => [:show, :update]
  end
  
  resources :posts do
    resources :comments, only: :create, module: :posts do
      collection do
        post :build
        post :preview
      end
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
