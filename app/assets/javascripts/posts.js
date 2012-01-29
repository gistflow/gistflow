$(document).ready(function(){
  $(".import_gist").click(function(){
    var txt = "{gist:" + $(this).attr('id') + "}";
    var box = $("#post_body");
    box.val(box.val() + txt);
  });
});