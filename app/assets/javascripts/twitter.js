$(function(){
  
  var content = $('#post_content')
  var status  = $('#post_status')
  var disable = $("#post_status_toggle")
  var new_status = function(text) {
    text = text.replace('', '')
    text = text.slice(0, 119)
    if (text.indexOf('http://goo.gl/xxxxxx') == -1) {
      text = text + " http://goo.gl/xxxxxx "
    }
    return text
  }
  
  disable.on('change', function(){
    if ($(this).is(':checked')) {
      status.val('')
    } else {
      content.trigger('blur')
    }
  })
  
  content.on('keypress blur', function(){
    if (!disable.is(':checked') && !status.data('changed')) {
      status.val(new_status(content.val()))
    }
  })
  
  status.on('keypress blur', function(e, b){
    $(this).data('changed', true)
    if (disable.is(':checked')) disable.attr('checked', null)
    if ($(this).val() == '') {
      var position = $(this).val().length
      $(this).val(new_status($(this).val()))
      $(this).setCursorPosition(position)
    } else {
      $(this).val(new_status($(this).val()))
    }
  })
})