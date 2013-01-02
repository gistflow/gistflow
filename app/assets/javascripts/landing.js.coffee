$ ->
  $('div.join-sign-up button').hover (->
      $('div.octoears').addClass('hovered-sign-in')
    ), ->
      $('div.octoears').removeClass('hovered-sign-in')