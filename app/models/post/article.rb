class Post::Article < Post
  validates :title, :presence => true
end
