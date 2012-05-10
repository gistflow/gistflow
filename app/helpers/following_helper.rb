module FollowingHelper
  def following_form user
    if user_signed_in? && user != current_user
      following = current_user.followings.where(followed_user_id: user.id).
        first_or_initialize
      render partial: 'account/followings/form', locals: {
        user:      user,
        following: following
      }
    end
  end
  
  def followers_link user
    title = "<b>#{user.followers.count}</b> Followers".html_safe
    link_to_if can?(:follow, user), title, user_followers_path(user)
  end
  
  def followed_users_link user
    title = "<b>#{user.followed_users.count}</b> Following".html_safe
    link_to_if can?(:follow, user), title, user_followings_path(user)
  end
end
