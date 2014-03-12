HawCLI = require 'haw/lib/cli'
path = require 'path'

configDir = path.dirname module.filename

class CLI extends HawCLI
  @::configFiles.splice 1, 0, path.resolve configDir, 'haw-config'
  @::options.push ['project-config', null, 'The readymade project definition to load', 'project']

module.exports = CLI
