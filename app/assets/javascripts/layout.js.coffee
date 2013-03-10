$ ->
  fullHeight = $('body:first').height()
  headerHeight = $('.main-header:first').height()
  footerHeight = $('.main-footer:first').height() + 20 # (margin-top)
  height = fullHeight - headerHeight - footerHeight
  $('div.main-row:first').css('min-height', height)