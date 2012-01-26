Gistflow::Application.routes.draw do
  match '/auth/:provider/callback' => 'users#create'
  root to: 'posts#index'
end
