class API < Grape::API
  version 'v1', using: :path, vendor: 'gistflow'
  prefix 'api'
  format :json
  
  helpers do
    def current_user
      token = env['HTTP_X_GISTFLOW_TOKEN']
      User.find_by_token(token) if token
    end
  end
  
  desc "Returns flow posts"
  get '/flow' do
    posts = current_user.flow.page(params[:page]).to_a
    posts.map { |p| PostSerializer.new(p) }
  end
end
