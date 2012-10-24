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
      showGists: ->
    
    class GistImporter
      constructor: (@username, @storage) ->
      imported: ->
        @storage.list()
      import: ->
        url = 'https://api.github.com/users/' + @username + '/gists'
        # $.getJSON url, (gists) ->
        gists = _(window.gist_list)
        @storage.maximum(gists.length)
        gists.each (item) =>
          unless @imported().contains(item.id)
            @detail(item)
      detail: (item) ->
        console.log(item)
        url = 'https://api.github.com/' + item.id
        # $.getJSON url, (gist) ->
        gist = window.gist
        @storage.store(gist)
    
    class GistStorage
      constructor: (@username) ->
        @storage = localStorage
        if @storage.username != @username
          @storage.clear
        @storage.setItem('username', @username)
        # @length
      maximum: (length) ->
        # @length = 
      filled: ->
        if 
        false
      list: ->
        @list.map (gist) ->
          gist.id
      store: (gist) ->
        localStorage.setItem 'gist:' + gist.id, JSON.encode(gist)
    
    # controller
    username = window.current_user.username
    storage  = new GistStorage(username)
    view     = new GistView
    if storage.filled()
      view.showGists()
    else
      importer = new GistImporter(username, storage)
      importer.import()
