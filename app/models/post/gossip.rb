class Post::Gossip < Post
protected
  
  def create_indextank_document
    Post.index.document(id).add(title: (title || ''), content: content)
  end
  
  def update_indextank_document
    Post.index.document(id).add(title: (title || ''), content: content)
  end
end
