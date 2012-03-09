class RemembranceBuilder < ViewBuilder
  def title
    super('Remembrance')
  end
  
  def posts
    content_tag(:ul) do
      user.remembrance.map do |post|
        content_tag(:li) do
          [ link_to(post.user, url_helpers.user_path(:id => post.user)),
            post.link_name,
            link_to('show', url_helpers.post_path(:id => post.id))
          ].join(' ').html_safe
        end
      end.join.html_safe
    end
  end
  
protected
  
  def wrap_class
    'remembrance'
  end
end
