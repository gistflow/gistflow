$(function(){
  $(document).on('click', 'form#new_comment input[type.submit]', function(){
    $(this).parents('form#new_comment:first').attr('action', $(this).attr('rel'))
  })
  
  $(document).on('ajax:success', 'form#new_comment', function(e, data){
    if (data.comment) {
      $(this).prev().before(data.comment);
      $('section.comments p.no_comments').remove();
      $(this).prevAll('article.comment:first').on('hover', function(){
        $(this).find('div.controls').toggle();
      });
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
  
  $(document).on('ajax:success', 'a.delete_comment', function(e, data){
    var message = 'Comment was deleted.';
    $(this).parents().closest('article.comment').remove();
    $.flash(message, 'alert-success');
  })
  
  $(document).on('ajax:error', 'a.delete_comment', function(e, data){
    flash_error();
  })
  
  $('article.comment').on('hover', function(){
    $(this).find('div.controls').toggle();
  })
  
  $(document).on('ajax:success', 'a.edit_comment', function(e, data){
    var form = $(data.form);
    $(this).parents().closest('article.comment').replaceWith(data.form);
    $('textarea').autosize().tabby({tabString: '  '});
  })
  
  $(document).on('ajax:error', 'a.edit_comment', function(e, data){
    flash_error();
  })
  
  $(document).on('ajax:success', 'form.edit_comment', function(e, data){
    if (data.comment) {
      $(this).replaceWith(data.comment);
      var controls_id = $(data.comment).find('div.controls').attr('id');
      var comment = $('div#' + controls_id).parents()
        .closest('article.comment');
      
      comment.on('hover', function(){
        $(this).find('div.controls').toggle();
      });
    }
  })
  
  $(document).on('ajax:error', 'form.edit_comment', function(e, data){
    flash_error();
  })
});

function flash_error() {
  $.flash('Smth went wrong.', 'alert-error');
}