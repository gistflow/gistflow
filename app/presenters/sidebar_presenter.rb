class SidebarPresenter
  attr_reader :user
  attr_accessor :show_user
  
  def initialize(user)
    @user = user
  end
  
  def tags
    @tags ||= user.tags.limit(10)
  end
  
  def posts
    @posts || user.favorite_posts.includes(:user).limit(5)
  end
  
  def gists
    []
  end
end
