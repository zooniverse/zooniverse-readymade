# window.jQuery = require 'jquery'

Project = require '../../../src/project'
projectConfiguration = require 'readymade-project-configuration'

if projectConfiguration.title?
  titleContainer = document.createElement 'div'
  titleContainer.innerHTML = projectConfiguration.title
  document.title = titleContainer.textContent

if projectConfiguration.background?
  backgroundContainer = document.getElementById 'readymade-site-background'
  backgroundContainer.style.backgroundImage = "url('#{projectConfiguration.background}')"

window.zooniverseProject = new Project projectConfiguration
