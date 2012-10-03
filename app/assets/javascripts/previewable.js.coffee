class Previewable
  constructor: (attributes) ->
    @form = attributes.form
    @raw = @form.find "textarea.raw"
    @container = @form.find "div.preview"
    
    @previewButton = @form.find("a.preview")
    @previewButton.on 'click', @preview
    
    @editButton = @form.find("a.edit")
    @editButton.on 'click', @edit
  
  preview: =>
    $.ajax(
      type: "POST"
      url:  "/api/markdown"
      data: { raw: @raw.val() }
    ).done (data) =>
      @raw.hide()
      @container.show()
      @container.html(data)
      @previewButton.hide()
      @editButton.show()
  
  edit: =>
    @container.hide()
    @raw.show()
    @editButton.hide()
    @previewButton.show()

$(document).ready ->
  $("form.previewable").each (i, form) ->
    new Previewable form: $(form)
