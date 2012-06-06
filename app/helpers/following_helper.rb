module FollowingHelper
  def followers_link user
    count = user.followers.count
    text = 'Follower'.pluralize(count)
    title = "<b class='followers_count'>#{count}</b> #{text}".html_safe
    link_to title, user_followers_path(user)
  end
  
  def followed_users_link user
    title = "<b class='followings_count'>#{user.followed_users.count}</b> Following".html_safe
    link_to title, user_followings_path(user)
  end
end