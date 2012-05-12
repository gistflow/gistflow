$(function(){
  $('.alert.error').fadeIn('fast').delay(2000).fadeOut('fast')
  $('div.alert').children('a.close').click(function(){
    $(this).parent().hide()
  })
})
