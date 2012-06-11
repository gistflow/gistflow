module Todolist
  # todo list methods
  # MOVE them to badges soon

  def todolist_cache_key
    "todolist:#{id}"
  end

  def author?
    posts.non_deleted.any?
  end

  def subscriber?
    tags.any?
  end

  def fan?
    likes.any?
  end

  def follower?
    followings.any?
  end

  def learner?
    bookmarks.any?
  end

  def talker?
    comments.non_deleted.any?
  end

  def observer?
    observings.any?
  end

  def todolist_finished?
    author? && 
    subscriber? &&
    fan? &&
    follower? &&
    learner? &&
    talker? &&
    observer?
  end
end