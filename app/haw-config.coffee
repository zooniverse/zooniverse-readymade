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

  @generateFile = ->
    @project = require.resolve path.resolve @project
    delete require.cache[@project]
    @projectConfig = require @project
    @projectConfig.toString = -> toSource this
    Server::generateFile.apply @, arguments

  @modifyStylus = (styl) ->
    for file in @projectConfig.css || []
      styl.import path.resolve path.dirname(@project), file

  @modifyBrowserify = (b) ->
    for file in @projectConfig.js || []
      b.add path.resolve path.dirname(@project), file
