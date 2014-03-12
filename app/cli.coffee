HawCLI = require 'haw/lib/cli'
path = require 'path'

configDir = path.dirname module.filename

class CLI extends HawCLI
  @::configFiles.splice 1, 0, path.resolve configDir, 'haw-config'
  @::options.push ['project-config', null, 'The readymade project definition to load', 'project']

  mergeConfigs: ->
    config = super

    projectConfigPath = try require.resolve path.resolve config['project-config']
    if projectConfigPath?
      projectConfig = require projectConfigPath
      if projectConfig.static?
        config.mount[path.resolve path.dirname(projectConfigPath), projectConfig.static] = '/'

    config

module.exports = CLI
