module FollowingHelper
  def followers_link user
    count = user.followers.count
    text = 'Follower'.pluralize(count)
    title = "<strong class='followers_count'>#{count}</strong> #{text}".html_safe
    link_to title, user_followers_path(user)
  end
  
  def followed_users_link user
    title = "<strong class='followings_count'>#{user.followed_users.count}</strong> Following".html_safe
    link_to title, user_followings_path(user)
  end
end