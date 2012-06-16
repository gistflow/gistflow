module Models
  module Todolistable
    extend ActiveSupport::Concern
    
    Struct.new('Task', :name, :completed)
    
    TASKS = {
      signup_task:    :registered?,
      post_task:      :author?,
      like_task:      :fan?,
      subscribe_task: :subscriber?,
      bookmark_task:  :learner?,
      comment_task:   :talker?,
      follow_task:    :follower?,
      observe_task:   :observer?
    }

    def tasks
      @tasks ||= begin
        TASKS.map do |task, method|
          name = I18n.t "welcome_todolist_tasks.#{task}"
          Struct::Task.new name, send(method)
        end
      end
    end
    
    def todolist_cache_key
      "todolist:#{id}"
    end
    
    def registered?
      true
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