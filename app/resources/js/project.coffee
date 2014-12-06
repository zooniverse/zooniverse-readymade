translate = require 'zooniverse/lib/translate'
translations =
  en: require '../../../lib/translations/en'

Project = require '../../../lib/project'
projectConfiguration = require 'zooniverse-readymade/current-configuration'

for lang, keys of translations
  for key, value of keys
    translate.strings[lang]["readymade.#{key}"] = value

if projectConfiguration.title?
  titleContainer = document.createElement 'div'
  titleContainer.innerHTML = projectConfiguration.title
  document.title = titleContainer.textContent

currentProject = new Project projectConfiguration
module.exports = currentProject # Exposed as zooniverse-readymade/current-project
