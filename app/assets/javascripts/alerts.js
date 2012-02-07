$(function() {
  $('div.alert a.close').click(function(){
    $(this).parents('div.alert:first').remove()
  })
});
