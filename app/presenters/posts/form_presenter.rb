class Posts::FormPresenter
  attr_reader :post
  
  def initialize(post)
    @post = post
  end
  
  def github_gists
    post.user.github_gists.last(20)
  end
end
