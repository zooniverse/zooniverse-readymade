path = require 'path'
toSource = require 'tosource'

resourcesDir = path.resolve path.dirname(module.filename), 'resources'

freshRequire = (modulePath) ->
  modulePath = require.resolve path.resolve modulePath
  delete require.cache[modulePath]
  require modulePath

module.exports = (options) ->
  @port = 2005

  @mount[path.resolve resourcesDir, 'public'] = '/'

  @generate['/index.html'] = path.resolve resourcesDir, 'index.eco'
  @generate['/main.css'] = path.resolve resourcesDir, 'css', 'main.styl'
  @generate['/main.js'] = path.resolve resourcesDir, 'js','main.coffee'

  @modifyStylus = (styl) ->
    if @project?
      for file in @project.css || []
        styl.import path.resolve path.dirname(path.resolve @['project-config']), file

      styl.define 'project-background', @project.background

  @modifyBrowserify = (b) ->
    if @['project-config']?
      b.require path.resolve(@['project-config']), expose: 'readymade-project-configuration'

    if @project?
      for file in @project.js || []
        b.add path.resolve path.dirname(path.resolve @['project-config']), file
