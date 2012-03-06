class Post::ArticlesController < Post::BaseController
  
  
  private
    def model
      Post::Article
    end
end