$(document).ready ->
  if window.current_user && _(Storage).isObject()
    
    # models
    class GistView
      constructor: (@storage) ->
        @section = $('section.gists')
        @progressBar = $('div.gists-progress-bar')
        @inline_gist_template = _.template('
          <li>
            <a href="/posts/new" class="add">add</a>
            <span><%= description %></span>
            <a href="https://gist.github.com/gists/<%= id %>/edit">edit</a>
          </li>
        ')
      
      # show saved to storage gists
      showGists: =>
        @progressBar.hide()
        ul = $('<ul>')
        @storage.list().each (id) =>
          gist = @storage.getGist(id)
          options = { description: gist.description, id: gist.id }
          li = @inline_gist_template(options)
          ul.append(li)
        @section.append(ul)
      
      # handle stored event
      updateProgress: () =>
        $('div.bar', @progressBar).width('' + @storage.progress() + '%')
        
    class GistImporter
      constructor: (@username, @storage) ->
      
      # ids of imported gists
      imported: ->
        @storage.list()
      
      # start new import
      import: ->
        url = 'https://api.github.com/users/' + @username + '/gists'
        $.getJSON url, (gists) =>
          @storage.maximum(gists.size())
          gists.each (gist) =>
            unless @imported().contains(gist.id)
              @detail(gist)
      
      # get detail data of gist
      detail: (gist) ->
        url = 'https://api.github.com/' + gist.id
        $.getJSON url, (gist) =>
          gist = window.gist
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
    
    # controller
    username = window.current_user.username
    storage  = new GistStorage(username)
    view     = new GistView(storage)
    if storage.filled()
      view.showGists()
    else
      importer = new GistImporter(username, storage)
      storage.on('stored', view.updateProgress)
      storage.on('filled', view.showGists)
      importer.import()
