$(function(){
  $('article.post').each(function(i, post_html){
    var post = $(post_html)
    var author = post.data('author')
    var post_data = window.posts[post.data('id')]
    if (window.ratings) {
      var rating = window.ratings[author]
    
      // setup user's rating
      post.find('span.rating').html(rating)
    }
    
    // setup edit button
    if (!window.current_user || (window.current_user.username != author && !window.current_user.admin)) {
      post.find('a.edit').remove()
    }
    
    // setup comments count
    post.find('a.comment').html('<span>' + post_data.comments_count + '</span> <i class="icon-comments-alt"></i>')
    
    // setup likes
    var like = post.find('a.like')
    
    content = '<span>' + post_data.likes_count + '</span> <i class="icon-heart"></i>'
    if (window.current_user) {
      if (_.include(window.current_user.likes, post_data.id)) {
        like.attr('title', 'Unlike post')
        like.data('method', 'delete')
      } else {
        like.attr('title', 'Like post')
        content = '<span>' + post_data.likes_count + '</span> <i class="icon-heart-empty"></i>'
      }
    }
    like.html(content)
    
    // setup observing
    var observe = post.find('a.observe')
    if (window.current_user) {
      if (_.include(window.current_user.observings, post_data.id)) {
        observe.data('method', 'delete').removeClass('icon-eye-close')
          .addClass('icon-eye-open').attr('title', 'Unobserve')
      }
    } else {
      observe.remove()
    }
    
    // setup bookmarks
    var bookmark = post.find('a.bookmark')
    if (window.current_user) {
      if (_.include(window.current_user.bookmarks, post_data.id)) {
        bookmark.data('method', 'delete').removeClass('icon-bookmark-empty')
          .addClass('icon-bookmark').attr('title', 'Unbookmark')
      }
    } else {
      bookmark.remove()
    }
  })
  
  // setup followings
  $('a.follow').each(function(i, link_html){
    var link = $(link_html)
    if (window.current_user) {
      if (_.include(window.current_user.following, parseInt(link.data('id')))) {
        link.data('method', 'delete').html('Unfollow')
      }
    }
  })
  
  // setup subscriptions
  $('a.subscribe').each(function(i, link_html){
    var link = $(link_html)
    if (window.current_user) {
      if (_.include(window.current_user.subscriptions, parseInt(link.data('id')))) {
        link.data('method', 'delete').addClass('active')
      }
    }
  })
});