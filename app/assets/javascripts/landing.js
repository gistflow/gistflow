$(function(){
  setInterval(function() {
    var next_link = $('div.slider a.active').parent().next().find('a')
    if (next_link.length == 0) {
      next_link = $('div.slider a:first')
    }
    next_link.click()
  }, 3000)
  
  $(document).on('click', 'div.slider a', function(){
    var slider = $(this).parents('div.slider:first')
    var img = slider.find('img:first')
    slider.find('a').removeClass('active')
    $(this).addClass('active')
    img.attr('src', $(this).data('rel'))
  })
  
  $('div.more').hide()
  
  $(document).on('click', 'a.more', function(){
    var more = $('div.more')
    more.show()
    $('html, body').animate({ scrollTop: more.position().top }, 'normal')
    return false
  })
})