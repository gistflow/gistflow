$(function(){
  $('article.post').each(function(i, post_html){
    var post = $(post_html)
    var author = post.data('author')
    var post_data = window.posts[post.data('id')]
    
    // setup comments count
    post.find('a.comment').html('Comments (' + post_data.comments_count + ')')
    
    // setup likes
    var like_name
    if (post_data.likes_count == 1) {
      like_name = '1 Like'
    } else {
      like_name = post_data.likes_count + ' Likes'
    }
    var like = post.find('a.like')
    
    if (window.current_user) {
      var liked = _.include(window.current_user.likes, post_data.id)
      if (!liked && post.data('author') != window.current_user.username) {
        like.removeClass('disabled')
      }
    }
    post.find('a.like').html(like_name)
    
    // setup observing
    var observe = post.find('a.observe')
    if (window.current_user) {
      if (_.include(window.current_user.observings, post_data.id)) {
        observe.data('method', 'delete').html('Unobserve')
      }
    } else {
      observe.remove()
    }
    
    // setup bookmarks
    var bookmark = post.find('a.bookmark')
    if (window.current_user) {
      if (_.include(window.current_user.observings, post_data.id)) {
        bookmark.data('method', 'delete').html('Unbookmark')
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