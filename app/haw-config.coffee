path = require 'path'
fs = require 'fs'

appLibDir = path.resolve path.dirname module.filename
resourcesDir = path.resolve appLibDir, 'resources'

readResourceSync = (resource) ->
  fs.readFileSync path.resolve resourcesDir, resource

module.exports = ->
  @port = 2005 # It's ZOOS, get it? Haaa.

  @mount[path.resolve resourcesDir, 'public'] = '/'

  @generate['/index.html'] = path.resolve resourcesDir, 'index.eco'
  @generate['/main.css'] = path.resolve resourcesDir, 'css', 'main.styl'
  @generate['/main.js'] = path.resolve resourcesDir, 'js','main.coffee'

  @js = []
  @css = []

  @modifyBrowserify = (b) ->
    projectPath = try require.resolve path.resolve @project
    if projectPath?
      b.require projectPath, expose: 'zooniverse-readymade/current-configuration'

    b.require path.resolve(resourcesDir, 'js', 'project.coffee'), expose: 'zooniverse-readymade/current-project'

    for file in [].concat @js
      b.add path.resolve path.dirname(path.resolve @project), file

  @modifyStylus = (styl) ->
    for file in [].concat @css
      # NOTE: These are currently added *before* the main file.
      styl.import path.resolve file

  @init =
    default:
      'project.coffee': readResourceSync('project-template.coffee').toString()
      'project.styl': readResourceSync('project-template.styl').toString()
      public:
        'the-milky-way-fpo.jpg': readResourceSync 'the-milky-way-fpo.jpg'
        offline:
          'subjects.json': readResourceSync('offline-subjects-template.json').toString()
