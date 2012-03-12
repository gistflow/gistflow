class RemembranceBuilder < ViewBuilder
  def posts
    content_tag(:ul) do
      user.remembrance.map do |post|
        content_tag(:li) do
          [ link_to(post.user, url_helpers.user_path(:id => post.user.username)),
            post.link_name,
            link_to('show', url_helpers.post_path(:id => post.id))
          ].join(' ').html_safe
        end
      end.join.html_safe
    end
  end
  
protected
  
  def title
    'Remembrance'
  end
  
  def wrap_class
    'remembrance'
  end
  
  def show?
    user and user.remembrance.any?
  end
end
