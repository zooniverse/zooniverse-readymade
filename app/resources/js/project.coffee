Project = require '../../../src/project'
projectConfiguration = require 'zooniverse-readymade/current-configuration'

if projectConfiguration.title?
  titleContainer = document.createElement 'div'
  titleContainer.innerHTML = projectConfiguration.title
  document.title = titleContainer.textContent

module.exports = new Project projectConfiguration
