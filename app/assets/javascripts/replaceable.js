$(function(){
  $(document).on('ajax:success', '.replaceable', function(e, data){
    $(this).replaceWith(data.replaceable);
    var update_elements = data.update_elements;
    if(update_elements){
      _.each(update_elements, function(data, element){ 
        $('.' + element).text(data);
      });
    }
  })
});