$ ->
  $('.secretive').on 'click', ->
    $('code', @).html $(@).data('secret')
    $(@).removeClass('secretive')

  inputs = $('section.settings :input')

  inputs.on 'change', (e) ->
    $(e).trigger('change.rails')

  inputs.on 'ajax:beforeSend', ->
    $(@).prop('disabled', true)

  inputs.on 'ajax:complete', ->
    $(@).prop('disabled', false)

  inputs.on 'ajax:error', (xhr, status, error) ->
    $(@).addClass('error')

  inputs.on 'ajax:success', (xhr, status) ->
    $(@).removeClass('error')

  $('section.settings :checkbox').each (i, input) ->
    checkbox = $(input)
    value_input = $('section.settings input[type="hidden"][name="' + checkbox.attr('name') + '"]')
    value_input.on 'ajax:beforeSend', ->
      checkbox.prop('disabled', true)
    value_input.on 'ajax:complete', ->
      checkbox.prop('disabled', false)
    checkbox.on 'change', ->
      value_input.val(checkbox.is(':checked') ? '1' : '0')
      value_input.trigger('change')


  groups = _($('section.settings :radio')).groupBy 'name'
  _(groups).each (radios, name) ->
    radios = $(radios)
    value_input = $('section.settings input[type="hidden"][name="' + name + '"]')
    value_input.on 'ajax:beforeSend', ->
      radios.prop('disabled', true)
    value_input.on 'ajax:complete', ->
      radios.prop('disabled', false)
    radios.on 'change', ->
      radios.each (i, e) ->
        value_input.val(e.value) if e.checked
      value_input.trigger('change')
