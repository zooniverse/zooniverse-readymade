path = require 'path'
toSource = require 'tosource'

resourcesDir = path.resolve path.dirname(module.filename), 'resources'

module.exports = (options) ->
  @port = 2005 # It's ZOOS, get it? Haaa.

  @mount[path.resolve resourcesDir, 'public'] = '/'

  @generate['/index.html'] = path.resolve resourcesDir, 'index.eco'
  @generate['/main.css'] = path.resolve resourcesDir, 'css', 'main.styl'
  @generate['/main.js'] = path.resolve resourcesDir, 'js','main.coffee'

  @js = ''
  @css = ''

  @modifyBrowserify = (b) ->
    projectPath = try require.resolve path.resolve @project

    if projectPath?
      b.require projectPath, expose: 'readymade-project-configuration'

    for file in [].concat @js
      b.add path.resolve path.dirname(path.resolve @project), file

  @modifyStylus = (styl) ->
    for file in [].concat @css
      # NOTE: These are currently added *before* the main file.
      styl.import path.resolve file
