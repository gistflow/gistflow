class LandingsController < ApplicationController
  before_filter :explore, if: :user_signed_in?
  
  layout 'landing'
  
  def show
    @posts_count = Post.count
    @tags_count  = Tag.count
    @users_count = User.count
  end
  
protected
  
  def explore
    action = current_user.settings.default_wall_action
    redirect_to controller: :posts, action: action
  end
end
