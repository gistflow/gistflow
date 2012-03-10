class TagsBuilder < ViewBuilder
  def title
    super('Tags')
  end
  
  def tags
    content_tag(:ol) do
      if user.tags.any?
        user.tags.map do |tag|
          content_tag(:li) do
            link_to(tag, url_helpers.tag_path(:id => tag.name))
          end
        end.join.html_safe
      else
        link_to "Subscribe for tags", url_helpers.account_subscriptions_path
      end
    end
  end
  
protected
  
  def wrap_class
    'sidebar_tags'
  end
  
  def show?
    user
  end
end
