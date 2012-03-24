class Post::Gossip < Post
protected
  
  def create_indextank_document
    Post.index.document(id).add(title: raw_title, content: content)
  end
  
  def update_indextank_document
    Post.index.document(id).add(title: raw_title, content: content)
  end
  
  def raw_title
    read_attribute(:title) || ''
  end
end
