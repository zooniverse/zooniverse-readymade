Controller = require 'zooniverse/controllers/base-controller'

class SiteHeader extends Controller
  className: 'site-navigation'
  template: require './templates/site-header'
  elements:
    '.site-links ul': 'linksList'

  addNavLink: (href, label) ->
    @linksList.append "<li class='site-link'><a href='#{href}'>#{label}</a></li>"

module.exports = SiteHeader
