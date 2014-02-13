optimist = require 'optimist'
path = require 'path'
showOutput = require 'haw/lib/show-output'
fs = require 'fs'

options = optimist.options({
  c: alias: 'config', description: 'Project config file (.json, .js, or .coffee)'
  p: alias: 'port', description: 'Port on which to run the server'
  version: description: 'Print the version number'
}).argv

[command, commandArgs...] = options._

command = 'help' if options.help
command = 'version' if options.version or (options.v and not command)

configPath = require.resolve path.resolve process.cwd(), options.config

switch command
  when 's', 'serve', 'server'
    Server = require 'haw/lib/server'

    server = new Server
      port: options.port || process.env.PORT || 2005
      root: path.resolve __dirname, 'resources'
      generate:
        '/index.html': 'index.eco'
        '/main.css': 'main.styl'
        '/main.js': 'main.coffee'

      project: {} # This is re-required every time a file is generated.

      generateFile: ->
        delete require.cache[configPath]
        @project = require configPath
        Server::generateFile.apply @, arguments

      modifyStylus: (styl) ->
        for file in @project.css || []
          styl.import path.resolve path.dirname(configPath), file

      modifyBrowserify: (b) ->
        for file in @project.js || []
          b.add path.resolve path.dirname(configPath), file

    showOutput server

    server.serve()
