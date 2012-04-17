$(function(){
  
  var preview_button = $("form.new_comment").find('input.preview_button');  
  var comment_form = $("form.new_comment");
  var question_checkbox_block = comment_form.find('div.left');
  var fieldset = comment_form.find('fieldset');
  
  comment_form.find('input[type="submit"]').click(function(){
    if(fieldset.find('textarea#post_content').val().length == 0) {
     return false;
    }
    
    switch ($(this).val()) {
      case 'Write':
        question_checkbox_block.show();
        comment_form.find('article.comment').hide();
        fieldset.show();
        preview_button.attr('value', 'Preview');
        return false;
      case 'Preview':
        question_checkbox_block.hide();
        preview_button.attr('value', 'Write');
        break
      default:
        question_checkbox_block.show();
        fieldset.show();
        preview_button.attr('value', 'Preview');
    }
  })
  
  comment_form.live('ajax:success', function(e, data){
    comment_form.find('article.comment').remove();
    if(data.action == 'preview') {
      fieldset.hide();
      fieldset.prev().append(data.comment);
    } else {
      fieldset.find('textarea#post_content').val('');
      question_checkbox_block.find('#comment_question').attr('checked', false);
      $('section#comments').append(data.comment);
      $('p.no_comments').remove();
    }
  }).live('ajax:error', function(e, data){
    var message = JSON.parse(data.responseText.toString()).message;
    flash(message, 'alert-error');
  })
})