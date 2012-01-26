class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def index
    @posts = Post.all
  end
end
