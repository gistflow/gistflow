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
    link = $post.find('a.like:first')
    link.find('span:first').html '(' + data.likes_count + ')'
    if _(window.current_user.likes).include(id)
      link.data('method', 'delete')
      link.find('i:first')
        .removeClass('icon-heart-empty')
        .addClass('icon-heart')
    
    # fill bookmark
    if _(window.current_user.bookmarks).include(id)
      link = $post.find('a.bookmark:first')
      link.find('i:first')
        .removeClass('icon-bookmark-empty')
        .addClass('icon-bookmark')
    
    # fill comments
    link = $post.find('a.comments')
    link.find('span:first').html '(' + data.comments_count + ')'
  
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
      $link
        .data('method', data.method)
        .find('span:first').html '(' + data.count + ')'

    setTimeout callback, 280
  
  $posts.on 'ajax:success a.like', links_handler
  $posts.on 'ajax:success a.bookmark', links_handler
  
  # Comments
  $comments = $('article.comment')
  $comments.each (i, html) ->
    $comment = $(html)
    
    # show controlls
    if $comment.data('author') == window.current_user.username || window.current_user.admin
      $comment.find('div.comment-controls').removeClass('hidden')
  
  $comments.on 'ajax:success', 'a.comment-control-edit', (e, data) ->
    $link = $(@)
    $comment = $(e.delegateTarget)
    $comment.find('li.comment-control-active').removeClass('hidden')
    $comment.find('li.comment-control-inactive').addClass('hidden')
    $body = $comment.find('div.comment-body')
    $body
      .prop('contenteditable', true)
      .html(data.content)
      .focus()
  
  $comments.on 'ajax:before', 'a.comment-control-save', (e, data) ->
    $link = $(@)
    $comment = $(e.delegateTarget)
    content = $comment.find('div.comment-body').text()
    $link.data 'params', 'content=' + content
    true
    
  
  $comments.on 'ajax:success', 'a.comment-control-save, a.comment-control-cancel', (e, data) ->
    $comment = $(e.delegateTarget)
    $comment.find('li.comment-control-inactive').removeClass('hidden')
    $comment.find('li.comment-control-active').addClass('hidden')
    $body = $comment.find('div.comment-body')
    $body
      .prop('contenteditable', false)
      .html(data.html)
  
  $comments.on 'ajax:success', 'a.comment-control-remove', (e, data) ->
    $comment = $(e.delegateTarget)
    $comment.fadeOut
      done: ->
        $comment.remove()
    # if last comment show that there is no comments
  