$(function(){
  var search = $('#subscription_search')
  if (search.length > 0) {
    var filter_tags = function(){
      var value = $.trim(search.val())
      if (value.length > 0) {
        $('ul.subscriptions li.subscription').each(function(i, tag){
          if ($(this).find('a').html().indexOf(value) != -1) {
            $(this).show()
          } else {
            $(this).hide()
          }
        })
      } else {
        $('ul.subscriptions li.subscription').show()
      }
    }
    var interval
    search.on('focus', function(){
      interval = setInterval(filter_tags, 200)
    }).on('blur', function(){
      clearInterval(interval)
    })
  }
});
