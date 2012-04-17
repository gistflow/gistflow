$(function(){
  var gists = $('section.gists')
  if (gists) {
    $.getJSON('/account/gists.json', function(data){
      gists.replaceWith(data.div)
    })
  }

  $("article.post.detail a:contains('gist:')").each(function(){
    var id = $(this).html().match(/gist:(\d+)/)[1],
      link = ("/gists/" + id + ".json"),
      element = $(this)
    $.getJSON(link, function(data){
      element.html(data.div)
    })
  })
  
  var box = $("#post_content")
  $("a.importable-gist").live('click', function(){
    box.val(box.val() + "gist:" + $(this).data('gist-id') + " #" + $(this).data('gist-lang') + " ") 
    return false
  })
})