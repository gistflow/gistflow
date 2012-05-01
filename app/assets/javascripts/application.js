// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require auto_resize
//= require twitter_tooltips
//= require areacomplete
//= require highlight.pack
//= require jquery.tabby
//= require_tree .
$(function(){
  $('textarea').autosize()
  $('textarea').tabby({tabString: '  '})
  $('textarea').keydown(function (e) {
   if ((e.ctrlKey || e.metaKey) && e.keyCode == 13) {
     $(this).parents('form:first').submit()
   }
  });
  $('a[href=#]').click(function(){ return false })
    
  $('a.replaceable').live('ajax:success', function(e, data){
    $(this).replaceWith(data.new_link)
    if ($(this).hasClass('remembrance')){
      $.getJSON('/account/remembrance.json', function(data){
        $('section.remembrance').replaceWith(data.div)
      })
    }
  })
  
  var setup_observable_links = function(){
    $('a.observable.new').on('click', function(){
      $(this).parents('div.button-group').find('form.new_observing').submit()
      return false
    })
  }
  setup_observable_links()
  $('a.observable[data-method="delete"]').live('ajax:success', function(e, data){
    $(this).replaceWith(data.new_link)
    setup_observable_links()
  })
  
  $('form.new_observing').live('ajax:success', function(e, data){
    var container = $(this).parents('div.button-group')
    container.find('a.observable').replaceWith(data.new_link)
    $(this).remove()
  })
  
  $("li.subscription form").live('ajax:success', function(e, data){
    $(this).parent().replaceWith(data.new_form);
    link = $($('ul#subscriptions').find('a#' + data.link_id)[0]);
    if (link.length > 0) {
      link.parent().remove();
    } else {
      $('ul#subscriptions').append(data.tag_block);
    }
  })
  
  var content = $("#post_content")
  var status = $("#post_status")
  var tweet_enabler = $("#post_status_toggle")
  var update_twitter_status = function() {
    if (!status.data('changed') && !tweet_enabler.is(':checked') && content.val()) {
      status.val(content.val().slice(0, 119) + " http://goo.gl/xxxxxx")
    }
  }
  status.change(function(){ $(this).data('changed', true) })
  content.change(function(){ update_twitter_status() })
  
  update_twitter_status()
  
  $("#post_status_toggle").change(function(){
    if ($(this).is(':checked')) {
      status.val('')
    } else {
      update_twitter_status()
    }
  })
  
  $('a.flow_posts').tooltip({title: 'Posts tagged with your subscriptions.'});
  $('a.all_posts').tooltip({title: 'All posts regardless to subscriptions.'});
  $('a.feed_posts').tooltip({title: 'Posts by users you follow.'});
  
  
  $('a.hints').on('click', function(){
    $('div.markdown_hints').toggle();
  })
  
  $('textarea.at-username').atUsername();
  
  $('pre code').each(function(i, e) {hljs.highlightBlock(e)});
})
