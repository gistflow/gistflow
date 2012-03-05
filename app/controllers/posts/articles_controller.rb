class Posts::ArticlesController < Posts::BaseController
  
  
  private
    def model
      Post::Article
    end
end