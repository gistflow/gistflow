$ ->
  $(document).on 'click', 'div.slider a', ->
    link = $(this)
    slider = link.parents('div.slider:first')
    old_img = slider.find('img:first')
    new_img = $(new Image())
    new_img.attr 'src', link.data('rel')
    new_img.hide().insertAfter old_img
    slider.find('a').removeClass('active')
    link.addClass('active')
    new_img.fadeIn 250, ->
      old_img.remove()

  flipSlider = ->
    next_link = $('div.slider a.active').parent().next().find('a')
    next_link = $('div.slider a:first') unless next_link.length
    next_link.click()

  setInterval flipSlider, 3000

