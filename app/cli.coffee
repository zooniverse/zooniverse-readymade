HawCLI = require 'haw/lib/cli'
path = require 'path'

configDir = path.dirname module.filename

class CLI extends HawCLI
  @::configFiles.splice 0, 0, path.resolve configDir, 'haw-config'

  @::options.splice 0, 0,
    ['project', null, 'The readymade project definition to load', 'project']
    ['js', null, 'Extra .js or .coffee files to include']
    ['css', null, 'Extra .css or .styl files to include']

module.exports = CLI
