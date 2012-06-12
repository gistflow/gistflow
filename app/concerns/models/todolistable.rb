module Models
  module Todolistable
    extend ActiveSupport::Concern
    
    TASKS = {
      post_task:      :author?,
      like_task:      :fan?,
      subscribe_task: :subscriber?,
      bookmark_task:  :learner?,
      comment_task:   :talker?,
      follow_task:    :follower?,
      observe_task:   :observer?
    }

    def tasks
      TASKS.map do |task, method|
        I18n.t("welcome_todolist_tasks.#{task}") unless send(method)
      end.compact
    end
    
    def todolist_cache_key
      "todolist:#{id}"
    end

    def author?
      posts.any?
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
      comments.any?
    end

    def observer?
      observings.any?
    end

    def todolist_finished?
      TASKS.values.all? { |m| send m }
    end
  end
end