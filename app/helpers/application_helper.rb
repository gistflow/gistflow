module ApplicationHelper
  GIST_URL = "https://gist.github.com"  
  
  def gist_js_url id
    "#{GIST_URL}/#{id}.js"
  end
    
  def login_url
    if Rails.env.development?
      login_path
    else
      'https://github.com/login/oauth/authorize?client_id=83dfd929d47091e3902d'
    end
  end
  
  def avatar_image(user, size)
    image_tag user.gravatar(size)
  end
  
  def title(title)
    content_for(:title, title)
  end
  
  def credits
    creators = ['releu', 'makaroni4', 'agentcooper'].shuffle.map do |u|
      link_to "@#{u}", "https://github.com/#{u}"
    end
    
    "Created by #{creators[0]}, #{creators[1]} and #{creators[2]}".html_safe
  end
end
