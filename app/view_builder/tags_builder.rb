class TagsBuilder < ViewBuilder
  def tags
    if user.tags.any?
      content_tag(:ul) do
        user.tags.map do |tag|
          content_tag(:li) do
            link_to(tag, url_helpers.tag_path(:id => tag.name))
          end
        end.join.html_safe
      end
    else
      link_to "Subscribe for tags", url_helpers.account_subscriptions_path
    end
  end
  
protected

  def title
    'Tags'
  end
  
  def wrap_class
    'sidebar_tags'
  end
  
  def show?
    user
  end
end
