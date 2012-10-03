Gistflow::Application.routes.draw do
  match '/auth/github/callback'  => 'users#create'
  match '/auth/twitter/callback' => 'account/twitter#create'
  
  match '/login'  => 'sessions#create' unless Rails.env.production? || Rails.env.staging?
  match '/logout' => 'sessions#destroy'
  
  match '/flow'      => 'posts#flow'
  match '/all'       => 'posts#index'
  match '/bookmarks' => 'posts#bookmarks'
  
  get :sitemap, to: 'sitemap#show', as: :xml
  
  namespace :account do
    post   '/followings/:user_id' => 'followings#create',  :as => :follow
    delete '/followings/:user_id' => 'followings#destroy'
                                  
    post   '/bookmarks/:post_id' => 'bookmarks#create', :as => :bookmark
    delete '/bookmarks/:post_id' => 'bookmarks#destroy'
                                  
    post   '/observings/:post_id' => 'observings#create', :as => :observe
    delete '/observings/:post_id' => 'observings#destroy'
    
    post   '/subscriptions/:tag_id' => 'subscriptions#create', :as => :subscribe
    delete '/subscriptions/:tag_id' => 'subscriptions#destroy'
    resources :subscriptions, only: :index
    
    post   '/likes/:post_id' => 'likes#create', :as => :like
    delete '/likes/:post_id' => 'likes#destroy'
    
    resources :notifications, only: :index
    resource :settings, :only => [:show, :update]
    resource :profile, :only => [:show, :update]
  end
  
  resources :posts do
    get :new_private, on: :collection
    resources :comments, only: [:create, :edit, :update, :destroy], module: :posts do
      collection do
        post :build
        post :preview
      end
    end
  end
  
  resource :search, only: :create
  
  get '/empty_search'  => 'searches#empty', as: 'nil_search'
  get '/search/:query' => 'searches#show',  as: 'show_search'
  
  resources :tags, only: :show do
    resource :wiki, module: :tags, only: [:show, :edit, :update] do
      get 'history'
    end
  end
  
  resources :users, only: :show do
    scope module: :users do
      resources :followers, only: :index
      resources :followings, only: :index, path: '/following'
    end
  end
  
  namespace :admin do
    resources :users, only: :index
    resources :tags, only: [:index, :edit] do
      post :entity
    end
  end
  
  post '/api/markdown', to: 'markdown#create'
  
  root to: 'landings#show'
  match '*a', to: 'errors#not_found'
end
