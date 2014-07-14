jQuery = window.$

if navigator.userAgent.indexOf('iP') > -1
  $(document.body.parentNode).addClass 'isMobileSafari'

module.exports = require 'zooniverse-readymade/current-project'
