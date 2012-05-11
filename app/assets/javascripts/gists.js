$(function(){
  var gist_template = _.template(' \
    <li> \
      <a href="/posts/new">add</a> \
      <%= description %> \
      <a href="https://gist.github.com/gists/<%= id %>/edit">edit</a> \
    </li> \
  ')
  $.getJSON('https://api.github.com/users/releu/gists', function(gists){
    var section = $('section.gists')
    section.find('p').remove()
    var ul = $('<ul>')
    section.append(ul)
    $.each(gists, function(index, gist){
      ul.append(gist_template(gist))
    })
  })
  
  $("article.post a:contains('gist:')").click(function(){
    var article = $(this).parents('article:first')
    if (!article.hasClass('detail')) {
      document.location = article.attr('rel')
      return false
    }
  })
  
  $("article.post.detail a:contains('gist:')").each(function(){
    var id = $(this).html().match(/gist:(\d+)/)[1],
      link = ("/gists/" + id + ".json"),
      element = $(this)
    $.getJSON(link, function(data){
      element.replaceWith(data.div)
    })
  })
  
  var box = $("#post_content")
  $("a.importable-gist").live('click', function(){
    if(box.length > 0) {
      box.val(box.val() + "gist:" + $(this).data('gist-id') + " #" + $(this).data('gist-lang') + " ")
      return false;
    }
  })
})