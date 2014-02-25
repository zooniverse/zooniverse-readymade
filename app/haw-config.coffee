path = require 'path'
toSource = require 'tosource'
Server = require 'haw/lib/server'

module.exports = ->
  @port = 2005

  @root = path.resolve path.dirname(module.filename), 'resources'

  @generate =
    '/index.html': 'index.eco'
    '/main.css': 'main.styl'
    '/main.js': 'main.coffee'

  @project = '' # Pass this in.
  @projectConfig = {} # This is re-required every time a file is generated.
  @projectConfigString = '{}' # For use in index.html template

  @generateFile = ->
    delete require.cache[@project]
    @projectConfig = require path.resolve @project
    @projectConfigString = toSource @projectConfig
    Server::generateFile.apply @, arguments

  @modifyStylus = (styl) ->
    for file in @projectConfig.css || []
      styl.import path.resolve path.dirname(@project), file

  @modifyBrowserify = (b) ->
    for file in @projectConfig.js || []
      b.add path.resolve path.dirname(@project), file
