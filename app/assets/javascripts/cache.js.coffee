$ ->
  # Posts
  $posts = $('article.post')
  $posts.each (i, html) ->
    $post = $(html)
    
    id = Number($post.data('id'))
    data = window.posts[id]
    
    # show edit button
    
    if $post.data('author') == window.current_user.username || window.current_user.admin
      $post.find('div.post-links-group-manage').removeClass('hidden')
    
    # fill likes
    link = $post.find('a.like')
    link.find('span').html '(' + data.likes_count + ')'
    if _(window.current_user.likes).include(id)
      link.find('i:first')
        .removeClass('icon-heart-empty')
        .addClass('icon-heart')
    
    # fill bookmark
    if _(window.current_user.bookmarks).include(id)
      link = $post.find('a.bookmark')
      link.find('i:first')
        .removeClass('icon-bookmark-empty')
        .addClass('icon-bookmark')
    
    # fill comments
  
  $posts.on 'click a.replaceable', (e) ->
    $link = $(e.target)
    $icon = $link.find('i:first')
    $icon.removeClass()
    $icon.addClass('icon-refresh icon-spin')
  
  links_handler = (e, data) ->
    $link = $(e.target)
    $icon = $link.find('i:first')
    callback = () ->
      $icon
        .removeClass()
        .addClass(data.icon)
      $link.data('method', data.method)

    setTimeout callback, 240
  
  $posts.on 'ajax:success a.like', links_handler
  $posts.on 'ajax:success a.bookmark', links_handler