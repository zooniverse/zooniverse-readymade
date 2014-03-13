Controller = require 'zooniverse/controllers/base-controller'

class SiteBackground extends Controller
  className: 'readymade-site-background'
  template: require './templates/site-background'

  src: ''

  constructor: ->
    super
    @el.css 'backgroundImage', "url('#{@src}')"

module.exports = SiteBackground
