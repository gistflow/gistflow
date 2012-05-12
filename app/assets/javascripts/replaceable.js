$(function(){
  $(document).on('ajax:success', '.replaceable', function(e, data){
    $(this).replaceWith(data.replaceable)
  })
});
