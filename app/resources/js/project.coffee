Project = require '../../../lib/project'
projectConfiguration = require 'zooniverse-readymade/current-configuration'

if projectConfiguration.title?
  titleContainer = document.createElement 'div'
  titleContainer.innerHTML = projectConfiguration.title
  document.title = titleContainer.textContent

currentProject = new Project projectConfiguration
module.exports = currentProject # Exposed as zooniverse-readymade/current-project
