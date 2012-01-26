module ApplicationHelper
  GIST_URL = "https://gist.github.com"  
  
  def gist_js_url id
    "#{GIST_URL}/#{id}.js"
  end
    
end
