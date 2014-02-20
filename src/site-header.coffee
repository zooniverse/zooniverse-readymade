Controller = require 'zooniverse/controllers/base-controller'

class SiteHeader extends Controller
  className: 'readymade-site-header'
  template: require './templates/site-header'
  elements:
    '.readymade-site-links': 'linksList'

  addNavLink: (href, label) ->
    @linksList.append "<a href='#{href}' class='readymade-site-link'>#{label}</a>\n"

module.exports = SiteHeader
