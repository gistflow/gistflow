$(function(){
  var inline_gist_template = _.template(' \
    <li> \
      <a href="/posts/new">add</a> \
      <%= description %> \
      <a href="https://gist.github.com/gists/<%= id %>/edit">edit</a> \
    </li> \
  ')
  $.getJSON('https://api.github.com/users/releu/gists', function(gists){
    var section = $('section.gists')
    section.find('p').remove()
    var ul = $('<ul>')
    section.append(ul)
    $.each(gists, function(index, gist){
      ul.append(inline_gist_template(gist))
    })
  })
  
  $("article.post a:contains('gist:')").click(function(){
    var article = $(this).parents('article:first')
    if (!article.hasClass('detail')) {
      document.location = article.attr('rel')
      return false
    }
  })
  
  var detail_gist_template = _.template(' \
    <div class="gist"> \
      <pre> \
        <code class="<%= lang %>"><%= code %></code> \
      </pre> \
    </div> \
  ')
  
  $("article.post.detail a:contains('gist:')").each(function(){
    var id = $(this).html().match(/gist:(\d+)/)[1];
    var element = $(this);
    $.getJSON('https://api.github.com/gists/' + id, function(data){
      _.each(data.files, function(raw, name){
        var gist = detail_gist_template({ code: raw.content, lang: raw.language.toLowerCase() });
        element.after(gist);
      });
      // remove all rehighlighting
      $('pre code').each(function(i, e) { hljs.highlightBlock(e) });
      element.remove();
    })
  })
  
  var box = $("#post_content")
  $("a.importable-gist").live('click', function(){
    if(box.length > 0) {
      box.val(box.val() + "gist:" + $(this).data('gist-id') + " #" + $(this).data('gist-lang') + " ")
      return false;
    }
  })
})