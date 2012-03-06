class Post::Question < Post
  validates :title, :presence => true
end
