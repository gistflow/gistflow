$(function(){
  var inline_gist_template = _.template(' \
    <li> \
      <a href="/posts/new" class="add" data-id="<%= id %>" data-lang="<%= language %>">add</a> \
      <span><%= description %></span> \
      <a href="https://gist.github.com/gists/<%= id %>/edit">edit</a> \
    </li> \
  ')
  if (window.current_user) {
    var url = 'https://api.github.com/users/' + window.current_user.username + '/gists'
    $.getJSON(url, function(gists){
      var section = $('section.gists')
      
      if(gists.length == 0) {
        return false
      }
      
      var ul = $('<ul>')
      section.append(ul)
      section.find('p').remove()
      
      $.each(gists, function(index, gist){
        languages = _.map(gist.files, function(file, name){
          if (file.language) return '#' + file.language.toLowerCase()
        })
        languages = _.uniq(languages)
        languages = _.compact(languages)
        gist.language = languages.join(' ')
        if (_.isEmpty(gist.description)) {
          gist.description = gist.id
        }
        
        li = $(inline_gist_template(gist))
        li.hide().appendTo(ul).delay(3 * index).fadeIn('fast')
      })
      
      section.find('a.add').tooltip({title: 'Add gist to new post or comment'})
      
      section.show()
    })
  
    var field_gist = _.template('gist:<%= id %> <%= lang %> ')
  
    $(document).on('click', 'section.gists a.add', function(e){
      e.preventDefault()
      var content = field_gist({
        id: $(this).data('id'),
        lang: $(this).data('lang')
      })
      var content_field = $('#post_content')
      if (content_field.length > 0) {
         content_field.val(content_field.val() + content)
      } else {
        document.location = $(this).attr('href') + '?content=' + escape(content)
      }
    })
  }
  
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
});
