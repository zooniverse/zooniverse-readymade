path = require 'path'
toSource = require 'tosource'
Server = require 'haw/lib/server'

freshRequire = (modulePath) ->
  modulePath = require.resolve path.resolve modulePath
  delete require.cache[modulePath]
  require modulePath

module.exports = (options) ->
  @project = freshRequire options.project

  @port = 2005

  @root = path.resolve path.dirname(module.filename), 'resources'

  # A restart is required to change static directories, but that shouldn't happen too often.
  if @project.static?
    @mount[path.resolve path.dirname(path.resolve(options.project)), @project.static] = '/'

  @generate =
    '/index.html': 'index.eco'
    '/main.css': 'css/main.styl'
    '/main.js': 'js/main.coffee'

  @generateFile = ->
    @project = freshRequire options.project
    Server::generateFile.apply @, arguments

  @modifyStylus = (styl) ->
    for file in @project.css || []
      styl.import path.resolve path.dirname(@project), file

    styl.define 'project-background', @project.background

  @modifyBrowserify = (b) ->
    b.require options.project, expose: 'readymade-project-configuration'

    for file in @project.js || []
      b.add path.resolve path.dirname(@project), file
