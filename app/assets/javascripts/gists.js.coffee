window.gist_list = [
  {
    "url": "https://api.github.com/gists/1",
    "id": "1",
    "description": "description of gist",
    "public": true,
    "user": {
      "login": "octocat",
      "id": 1,
      "avatar_url": "https://github.com/images/error/octocat_happy.gif",
      "gravatar_id": "somehexcode",
      "url": "https://api.github.com/users/octocat"
    },
    "files": {
      "ring.erl": {
        "size": 932,
        "filename": "ring.erl",
        "raw_url": "https://gist.github.com/raw/365370/8c4d2d43d178df44f4c03a7f2ac0ff512853564e/ring.erl"
      }
    },
    "comments": 0,
    "html_url": "https://gist.github.com/1",
    "git_pull_url": "git://gist.github.com/1.git",
    "git_push_url": "git@gist.github.com:1.git",
    "created_at": "2010-04-14T02:15:15Z"
  }
]

window.gist = {
  "url": "https://api.github.com/gists/1",
  "id": "1",
  "description": "description of gist",
  "public": true,
  "user": {
    "login": "octocat",
    "id": 1,
    "avatar_url": "https://github.com/images/error/octocat_happy.gif",
    "gravatar_id": "somehexcode",
    "url": "https://api.github.com/users/octocat"
  },
  "files": {
    "ring.erl": {
      "size": 932,
      "filename": "ring.erl",
      "raw_url": "https://gist.github.com/raw/365370/8c4d2d43d178df44f4c03a7f2ac0ff512853564e/ring.erl"
    }
  },
  "comments": 0,
  "html_url": "https://gist.github.com/1",
  "git_pull_url": "git://gist.github.com/1.git",
  "git_push_url": "git@gist.github.com:1.git",
  "created_at": "2010-04-14T02:15:15Z",
  "forks": [
    {
      "user": {
        "login": "octocat",
        "id": 1,
        "avatar_url": "https://github.com/images/error/octocat_happy.gif",
        "gravatar_id": "somehexcode",
        "url": "https://api.github.com/users/octocat"
      },
      "url": "https://api.github.com/gists/5",
      "created_at": "2011-04-14T16:00:49Z"
    }
  ],
  "history": [
    {
      "url": "https://api.github.com/gists/1/57a7f021a713b1c5a6a199b54cc514735d2d462f",
      "version": "57a7f021a713b1c5a6a199b54cc514735d2d462f",
      "user": {
        "login": "octocat",
        "id": 1,
        "avatar_url": "https://github.com/images/error/octocat_happy.gif",
        "gravatar_id": "somehexcode",
        "url": "https://api.github.com/users/octocat"
      },
      "change_status": {
        "deletions": 0,
        "additions": 180,
        "total": 180
      },
      "committed_at": "2010-04-14T02:15:15Z"
    }
  ]
}

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
        @storage.list.each (id) =>
          gist = @storage.getGist(id)
          console.log(gist)
        @section.append(ul)
      
      # handle stored event
      updateProgress: () =>
        $('div.bar', @progressBar).width('' + @storage.progress() + '%')
      
    
    class GistImporter
      constructor: (@username, @storage) ->
      
      # ids of imported gists
      imported: ->
        @storage.list
      
      # start new import
      import: ->
        url = 'https://api.github.com/users/' + @username + '/gists'
        # $.getJSON url, (gists) ->
        gists = _(window.gist_list)
        console.log("import")
        @storage.maximum(gists.size())
        gists.each (gist) =>
          unless @imported().contains(gist.id)
            @detail(gist)
      
      # get detail data of gist
      detail: (gist) ->
        url = 'https://api.github.com/' + gist.id
        # $.getJSON url, (gist) ->
        gist = window.gist
        @storage.store(gist)
    
    class GistStorage
      constructor: (@username) ->
        @storage = localStorage
        if @storage.username != @username
          @storage.clear
        @storage.setItem('username', @username)
        
        @list = @getList()
        @length = @list.length
        
      # set the length of the user gists
      maximum: (length) ->
        @length = length
      
      # all gists loaded?
      filled: ->
        if (new Date().getTime() - @lastUpdate()) < 24 * 60 * 1000
          false
        else
          @length == @list.length && @length > 0
      
      # return a percent of loading
      progress: ->
        if @length > 0
          @list.length * 100 / @length
        else
          100
      
      # store gist to storage
      # trigger stored event with gist id
      # trigger filled event when loads last gist
      store: (gist) ->
        console.log("store")
        localStorage.setItem 'gists:' + gist.id, JSON.stringify(gist)
        @pushTolist gist.id
        $(@).trigger('stored')
        if @length == @list.size()
          $(@).trigger('filled')
      
      # update list and do persistance
      pushTolist: (id) ->
        current_list = @getList()
        current_list.push(id)
        localStorage.setItem('gists:ids', JSON.stringify(current_list.toArray()))
      
      # return list from storage or empty
      getList: ->
        if jsoned_list = localStorage.getItem('gists:ids')
          _(JSON.parse(jsoned_list))
        else
          _([])
      
      # get gist's json
      getGist: (id) ->
        json = localStorage.getItem('gists:' + id)
        JSON.parse(json)
      
      # return last update time or 0
      lastUpdate: ->
        localStorage.getItem('gists:updated_at') || 0
      
      # update update time to current
      touchUpdate: ->
        localStorage.setItem 'gists:updated_at', new Date().getTime()
      
      # delegate bind to jQuery
      bind: (event, callback) ->
        $(@).bind(event, callback)
    
    # controller
    username = window.current_user.username
    storage  = new GistStorage(username)
    view     = new GistView(storage)
    if storage.filled()
      console.log('_filled')
      view.showGists()
    else
      importer = new GistImporter(username, storage)
      console.log('_import')
      storage.bind('stored', view.updateProgress)
      storage.bind('filled', view.showGists)
      importer.import()
