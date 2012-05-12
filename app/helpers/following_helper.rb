module FollowingHelper
  def followers_link user
    title = "<b>#{user.followers.count}</b> Followers".html_safe
    link_to_if can?(:follow, user), title, user_followers_path(user)
  end
  
  def followed_users_link user
    title = "<b>#{user.followed_users.count}</b> Following".html_safe
    link_to_if can?(:follow, user), title, user_followings_path(user)
  end
end
