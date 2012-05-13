class LandingsController < ApplicationController
  layout 'landing'
  
  def show
    @posts_count = Post.count
    @tags_count  = Tag.count
    @users_count = User.count
  end
end
