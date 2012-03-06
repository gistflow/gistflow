class Post::QuestionsController < Post::BaseController
  
  
  private
    def model
      Post::Question
    end
end