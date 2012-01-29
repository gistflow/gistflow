Gistflow::Application.routes.draw do
  match '/auth/:provider/callback' => 'users#create'
  resources :posts
  root to: 'posts#index'
end
