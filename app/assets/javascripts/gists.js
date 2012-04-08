$(function(){
  var gists = $('section.gists')
  if (gists) {
    $.getJSON('/account/gists.json', function(data){
      gists.replaceWith(data.div)
    })
  }

  $("div.gistable").each(function(){
    var id = $(this).data('gist-id'),
      link = ("/gists/" + id + ".json"),
      element = $(this)
    $.getJSON(link, function(data){
      element.removeClass("loading")
      element.html(data.div)
    })
  })
  
  var box = $("#post_content")
  $("a.importable-gist").live('click', function(){
    box.val(box.val() + "gist:" + $(this).data('gist-id') + " #" + $(this).data('gist-lang') + " ") 
    return false
  })
})