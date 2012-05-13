$(function(){
  $(document).on('click', 'form#new_comment input[type.submit]', function(){
    $(this).parents('form#new_comment:first').attr('action', $(this).attr('rel'))
  })
  
  $(document).on('ajax:success', 'form#new_comment', function(e, data){
    if (data.comment) {
      $(this).after(data.comment)
      $('section.comments p.no_comments').remove()
    }
    var form = $(data.form)
    $(this).replaceWith(data.form)
    // fix to local
    $('textarea').autosize().tabby({tabString: '  '})
  })
  
  $(document).on('ajax:error', 'form#new_comment', function(e, data){
    var message = JSON.parse(data.responseText.toString()).message;
    $.flash(message, 'alert-error');
  })
});
