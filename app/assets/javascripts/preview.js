$(function(){
  $(document).on('click', 'form#new_comment input[type=submit]', function(){
    $(this).parents('form#new_comment:first').attr('action', $(this).attr('rel'))
  })
  
  // callback when comment is previewed or commited
  $(document).on('ajax:success', 'form#new_comment', function(e, data){
    if (data.comment) {
      $(this).prev().before(data.comment);
      $('section.comments p.no_comments').remove();
    }
    var form = $(data.form);
    $(this).replaceWith(form);
    form.find('textarea').autoResize().tabby({tabString: '  '}).trigger('input.resize');
  });
  
  $(document).on('ajax:error', 'form#new_comment', function(e, data){
    var message = JSON.parse(data.responseText.toString()).message;
    $.flash(message, 'alert-error');
  })
  
  $(document).on('ajax:success', 'a.delete_comment', function(e, data){
    var message = 'Comment was deleted.';
    $(this).parents().closest('article.comment').remove();
    $.flash(message, 'alert-success');
  })
  
  $(document).on('ajax:error', 'a.delete_comment', function(e, data){
    flash_error();
  })
  
  // callback when user switch from previewing comment to editing
  $(document).on('ajax:success', 'a.edit_comment', function(e, data){
    var form = $(data.form);
    $(this).parents().closest('article.comment').replaceWith(data.form);
    $('form.edit_comment').find('textarea').autoResize().tabby({tabString: '  '}).trigger('input.resize');
  })
  
  $(document).on('ajax:error', 'a.edit_comment', function(e, data){
    flash_error();
  })
  
  $(document).on('ajax:success', 'form.edit_comment', function(e, data){
    if (data.comment) {
      $(this).replaceWith(data.comment);
      $('textarea').trigger('input.resize');
    }
  })
  
  $(document).on('mouseenter mouseleave', 'article.comment', function(){
    if (window.current_user.admin || window.current_user.username == $(this).data('author')) {
      $(this).find('div.controls').toggle();
    }
  });
  
  $(document).on('ajax:error', 'form.edit_comment', function(e, data){
    flash_error();
  })
});

function flash_error() {
  $.flash('Smth went wrong.', 'alert-error');
}