Project = require '../../../src/project'
projectConfiguration = require 'readymade-project-configuration'

if projectConfiguration.title?
  titleContainer = document.createElement 'div'
  titleContainer.innerHTML = projectConfiguration.title
  document.title = titleContainer.textContent

window.zooniverseProject = new Project projectConfiguration
