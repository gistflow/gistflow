class Search
  attr_reader :page_path
  
  def initialize(query)
    query.strip!
    @page_path = case query[0]
    when '#' then
      url_helper.tag_path(:id => query[1..-1])
    when '@' then
      url_helper.user_path(query[1..-1])
    else
      url_helper.root_path(:text => query)
    end
  end
  
protected
  
  def url_helper
    Rails.application.routes.url_helpers
  end
end
