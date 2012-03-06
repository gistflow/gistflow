class Search
  attr_reader :page_path
  
  delegate :url_helpers, :to => :'Rails.application.routes'
  
  def initialize(query)
    query.strip!
    @page_path = case query[0]
    when '#' then
      url_helpers.tag_path(:id => query[1..-1])
    when '@' then
      url_helpers.user_path(query[1..-1])
    else
      url_helpers.root_path(:text => query)
    end
  end
end
