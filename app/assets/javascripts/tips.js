$(function(){
  $('a.flow_posts').tooltip({title: 'Posts tagged with your subscriptions.'})
  $('a.all_posts').tooltip({title: 'All posts regardless to subscriptions.'})
  $('a.followed_posts').tooltip({title: 'Posts by users you follow.'})
  $('a.notification_link').tooltip({title: $(this).data('title')})
  $('div.search').tooltip({
    title: 'Search for text, #tag or @username.',
    placement: 'bottom'
  })
});
