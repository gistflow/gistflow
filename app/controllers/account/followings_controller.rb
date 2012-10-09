class Account::FollowingsController < ApplicationController
  cache_sweeper :user_sweeper
  prepend_before_filter :authenticate!, only: [:create, :destroy]
  
  def create
    @user = find_user(params[:user_id])
    current_user.follow(@user)
    link = render_to_string(inline: "<%= link_to_unfollow(@user) %>")
    render json: { 
      replaceable: link,
      update_elements: {
        # css_class: new_value
        followers_count: @user.followers.count
      }
    }
  end
  
  def destroy
    @user = find_user(params[:user_id])
    current_user.unfollow(@user)
    link = render_to_string(inline: "<%= link_to_follow(@user) %>")
    render json: { 
      replaceable: link,
      update_elements: {
        followers_count: @user.followers.count
      }
    }
  end
  
protected
  
  def find_user(username)
    User.find_by_username(username)
  end
end
