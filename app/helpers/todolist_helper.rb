module TodolistHelper
  TASKS = {
    post_task: :author?,
    like_task: :fan?,
    subscribe_task: :subscriber?,
    bookmark_task: :learner?,
    comment_task: :talker?,
    follow_task: :follower?,
    observe_task: :observer?
  }
  
  def todolist_tasks
    TASKS.map do |task, user_method|
      unless current_user.send(user_method)
        t("welcome_todolist_tasks.#{task}") 
      end
    end.compact
  end
end