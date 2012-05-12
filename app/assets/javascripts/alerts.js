jQuery.extend({
  flash: function(message, type_class){
    var block = $('div.alert');
    block.toggleClass(type_class);
    block.find('span.message').html(message);
    block.css('top', $(document).scrollTop() + 40);
    block.fadeIn().delay(2000).fadeOut('slow', function() {
      block.toggleClass(type_class);
    });
  }
});


$(function(){
  $('.alert.error').fadeIn('fast').delay(2000).fadeOut('fast')
  $('div.alert').children('a.close').click(function(){
    $(this).parent().hide()
  })
});