class Uninterruptable
  constructor: (attributes) ->
    @disabled = false

    @form = attributes.form
    @form.on 'submit', @checkState

  checkState: =>
    if @disabled then false else @disable()

  disable: =>
    @form.find('[type="submit"]').attr('disabled', true).addClass('disable')
    @disabled = true

$ ->
  $('form').each ->
    new Uninterruptable form: $(this)