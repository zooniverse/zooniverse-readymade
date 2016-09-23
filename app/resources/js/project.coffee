translate = window.zooniverse?.translate or require('zooniverse/lib/translate')
translations =
  en: require '../../../lib/translations/en'
  ja: require '../../../lib/translations/ja'
  es: require '../../../lib/translations/es'
  cs: require '../../../lib/translations/cs'
  ru: require '../../../lib/translations/ru'
  el: require '../../../lib/translations/el'

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
