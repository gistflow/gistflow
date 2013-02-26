$ ->
  # Posts
  $posts = $('article.post')
  $posts.each (i, html) ->
    $post = $(html)
    
    # show edit button
    
    if $post.data('author') == window.current_user.username || window.current_user.admin
      $post.find('div.post-links-group-manage').removeClass('hidden')
  
  $posts.on 'click a.replaceable', (e) ->
    $link = $(e.target)
    $icon = $link.find('i:first')
    $icon.removeClass()
    $icon.addClass('icon-refresh icon-spin')
  
  $posts.on 'ajax:success a.like', (e, data) ->
    $link = $(e.target)
    $icon = $link.find('i:first')
    callback = () ->
      $icon
        .removeClass()
        .addClass(data.icon)
      $link.data('method', data.method)
      
    setTimeout callback, 300
  
    