$ ->
  # Posts
  $('article.post').each (i, html) ->
    $post = $(html)
    
    # show edit button
    
    if $post.data('author') == window.current_user.username
      $post.find('div.post-links-group-manage').removeClass('hidden')
    