module TodolistHelper
  TASKS = {
    observe_task: :observer?,
    post_task: :author?,
    like_task: :fan?,
    subscribe_task: :subscriber?,
    bookmark_task: :learner?,
    comment_task: :talker?,
    follow_task: :follower?
  }
  
  def render_todolist
    TASKS.map do |task, user_method|
      send(task) unless current_user.send(user_method)
    end.compact.join.html_safe
  end
  
  protected
  def observe_task
    li 'Start observe post (receive notifications about comments)'
  end
  
  def post_task
    li 'Write code-related post'
  end
  
  def like_task
    li 'Like post, make somebody happy'
  end
  
  def subscribe_task
    li 'Subscribe for tag to expand your flow'
  end
  
  def bookmark_task
    li 'Bookmark post'
  end
  
  def comment_task
    li 'Write comment'
  end
  
  def follow_task
    li 'Follow user to expand your flow'
  end
  
  def li text
    content_tag :li, text, params
  end
end