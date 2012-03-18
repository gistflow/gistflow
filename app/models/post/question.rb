class Post::Question < Post
  validates :title, :presence => true
  
  def avatar_type
    :question
  end
end
