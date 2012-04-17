class Search
  attr_reader :page_path
  
  delegate :url_helpers, :to => :'Rails.application.routes'
  
  def initialize(query)
    query.to_s.strip!
    @page_path = if query.present?
      case query[0]
      when '#' then
        url_helpers.tag_path(:id => query[1..-1])
      when '@' then
        url_helpers.user_path(query[1..-1])
      else
        url_helpers.show_search_path(:query => query)
      end
    else
      url_helpers.nil_search_path
    end
  end
end
