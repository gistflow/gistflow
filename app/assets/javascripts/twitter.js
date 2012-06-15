$(function(){
  var content = $('#post_content'),
      title   = $('#post_title'),
      status  = $('#post_status'),
      length  = $('#status-length'),
      new_status = function(text) {
        text = text.replace('', '')
        text = text.slice(0, 119)
        return text
      }
  status.on('keydown change', function(){
    length.html(120 - status.val().length)
  })
  
  $('#twitter-copy').on('click', function(){
    status.val(new_status(title.val()))
    status.trigger('change')
    return false
  })
});
