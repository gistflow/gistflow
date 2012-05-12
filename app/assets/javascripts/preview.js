$(function(){
  $(document).on('click', 'form#new_comment input[type.submit]', function(){
    $(this).parents('form#new_comment:first').attr('action', $(this).attr('rel'))
  })
  
  $(document).on('ajax:success', 'form#new_comment', function(e, data){
    if (data.comment) {
      $(this).after(data.comment)
    }
    $(this).replaceWith(data.form)
  })
  
  $(document).on('ajax:error', 'form#new_comment', function(e, data){
    var message = JSON.parse(data.responseText.toString()).message;
    $.flash(message, 'alert-error');
  })
});
