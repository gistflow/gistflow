Gistflow::Application.routes.draw do
  match 'authentication' => 'users/create'
end
