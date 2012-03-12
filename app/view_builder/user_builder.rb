class UserBuilder < ViewBuilder
  def link_to_github
    link_to "#{user} on Github", "https://github.com/#{username}"
  end
  
protected

  def title
    options[:self] ? "Your Profile" : "#{user}'s profiles"
  end
  
  def show?
    user and params[:controller] == 'users'
  end
  
  def highlight?
    true
  end
end
