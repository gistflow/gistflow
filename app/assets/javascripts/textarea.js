$(function(){
  $('textarea').autoResize()  
  $('textarea').tabby({tabString: '  '})
  $('textarea').keydown(function (e) {
   if ((e.ctrlKey || e.metaKey) && e.keyCode == 13) {
     $(this).parents('form:first').submit()
   }
  })
  $('textarea.at-username').atUsername();  
  
  $('textarea').trigger('input.resize');
});
