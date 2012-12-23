$ ->
  $('div.join-sign-up button').hover (->
      $('section.join').addClass('hovered-sign-in')
    ), ->
      $('section.join').removeClass('hovered-sign-in')