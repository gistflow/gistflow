$(document).ready ->
  if window.current_user && _(Storage).isObject()
    
    # models
    class GistView
      constructor: (@storage) ->
        @section     = $('section.gists')
        @progressBar = $('div.gists-progress-bar', @section)
        @refresh     = $('a.gists-refresh', @section)
        @gists       = $('ul.gists', @section)
        @inline_gist_template = _.template('<li><a href="/posts/new" class="add">add</a> <span><%= description %></span> <a href="https://gist.github.com/gists/<%= id %>/edit">edit</a></li>')
        @gist_template = _.template("<% files.each(function(file) { %>```<%= String(file.language).toLowerCase() %>\n<%= file.content  %>\n```\n\n<% }) %>")
      
      # show saved to storage gists
      showGists: =>
        @progressBar.hide()
        @refresh.show()
        @textarea = $('#post_content')
        @storage.list().each (id) =>
          gist = @storage.getGist(id)
          options = { description: gist.description, id: gist.id }
          li = $(@inline_gist_template(options))
          template = @gist_template({ files: _(gist.files) })
          $('a.add', li).on 'click', =>
            if @textarea.val().length > 0
              @textarea.val(@textarea.val() + "\n")
            @textarea
              .val(@textarea.val() + template)
              .trigger('input.resize')
              .focus()
              .setCursorPosition(@textarea.val().length)
            return false
          @gists.append(li)
        @gists.show()
      
      # handle stored event
      updateProgress: () =>
        $('div.bar', @progressBar).width('' + @storage.progress() + '%')
        
    class GistImporter
      constructor: (@user, @storage) ->
        @username = @user.username
        @token = @user.oauth
      
      # ids of imported gists
      imported: ->
        @storage.list()
      
      # start new import
      import: ->
        @storage.clear()
        $.ajax
          url: 'https://api.github.com/users/' + @username + '/gists?token=' + @token
          success: (gists) =>
            gists = _(gists)
            @storage.maximum(gists.size())
            gists.each (gist) =>
              unless @imported().contains(gist.id)
                @detail(gist)
      
      # get detail data of gist
      detail: (gist) ->
        $.ajax
          url: 'https://api.github.com/gists/' + gist.id + '?token=' + @token
          success: (gist) =>
            @storage.store(gist)
    
    class GistStorage
      constructor: (@username) ->
        _(@).extend(Backbone.Events)
        @storage = localStorage
        if @storage.username != @username
          @storage.clear
        @storage.setItem('username', @username)
        
        @length = @list().size()
        
      # set the length of the user gists
      maximum: (length) ->
        @length = length
      
      # all gists loaded?
      filled: =>
        if (new Date().getTime() - @lastUpdate()) < 24 * 60 * 1000
          false
        else
          @length == @list().size() && @length > 0
      
      # return a percent of loading
      progress: ->
        if @length > 0
          @list().size() * 100 / @length
        else
          100
      
      # store gist to storage
      # trigger stored event with gist id
      # trigger filled event when loads last gist
      store: (gist) ->
        @storage.setItem 'gists:' + gist.id, JSON.stringify(gist)
        @pushTolist gist.id
        @trigger('stored')
        if @length == @list().size()
          @trigger('filled')
      
      # return a gist
      getGist: (id) ->
        if jsoned_gist = @storage.getItem('gists:' + id)
          JSON.parse(jsoned_gist)
        else
          null
      
      # update list and do persistance
      pushTolist: (id) ->
        current_list = @list()
        current_list.push(id)
        @storage.setItem('gists:ids', JSON.stringify(current_list.toArray()))
      
      # return list from storage or empty
      list: () ->
        if jsoned_list = @storage.getItem('gists:ids')
          _(JSON.parse(jsoned_list))
        else
          _([])
      
      # return last update time or 0
      lastUpdate: ->
        @storage.getItem('gists:updated_at') || 0
      
      # update update time to current
      touchUpdate: ->
        @storage.setItem 'gists:updated_at', new Date().getTime()
      
      # clear
      clear: ->
        @storage.clear()
        @storage.setItem('username', @username)
        null
    
    # controller
    user     = window.current_user
    storage  = new GistStorage(user.username)
    view     = new GistView(storage)
    importer = new GistImporter(user, storage)
    storage.on 'stored', view.updateProgress
    storage.on 'filled', view.showGists
    view.refresh.on 'click', ->
      importer.import()
      view.gists.html('')
      view.progressBar.show()
      view.updateProgress()
    
    if storage.filled()
      view.showGists()
    else
      importer.import()
      
