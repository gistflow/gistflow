$(function(){
  // var gists = $("#gists")
  // if (gists) {
  //   $.getJSON("/gists.json", function(data){
  //     gists.html(data.div)
  //   })
  // }

  $("div.gistable").each(function(){
    var id = $(this).data('gist-id'),
      link = ("/gists/" + id + ".json"),
      element = $(this)
    $.getJSON(link, function(data){
      element.html(data.div)
    })
  })
  
  var box = $("#post_body")
  $("a.importable-gist").live('click', function(){
    box.val(box.val() + "{gist:" + $(this).data('gist-id') + "}")
    return false
  })
})