Controller = require 'zooniverse/controllers/base-controller'

class SiteHeader extends Controller
  className: 'site-navigation'
  template: require './templates/site-header'
  elements:
    '.site-links': 'linksContainer'

  addNavLink: (href, label) ->
    @linksContainer.append "<a href='#{href}'>#{label}</a>"

module.exports = SiteHeader
