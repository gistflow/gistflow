class Post::Article < Post
  validates :title, :presence => true
  
  def avatar_type
    :article
  end
end
