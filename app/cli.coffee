optimist = require 'optimist'
path = require 'path'
showOutput = require 'haw/lib/show-output'

options = optimist.options({
  c: alias: 'config', description: 'Project config file (.json, .js, or .coffee)'
  p: alias: 'port', description: 'Port on which to run the server'
  version: description: 'Print the version number'
}).argv

[command, commandArgs...] = options._

command = 'help' if options.help
command = 'version' if options.version or (options.v and not command)

switch command
  when 's', 'serve', 'server'
    Server = require 'haw/lib/server'

    project = require path.resolve process.cwd(), options.config

    server = new Server
      port: options.port || process.env.PORT || 2005
      root: path.resolve __dirname, 'resources'
      generate:
        '/index.html': 'index.eco'
        '/main.css': 'main.styl'
        '/main.js': 'main.coffee'

      project: project

    showOutput server

    server.serve()
