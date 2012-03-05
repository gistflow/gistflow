class Posts::QuestionsController < Posts::BaseController
  
  
  private
    def model
      Post::Question
    end
end