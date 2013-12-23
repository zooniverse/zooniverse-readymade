Controller = require 'zooniverse/controllers/base-controller'

class SiteHeader extends Controller
  className: 'site-navigation'
  template: require './templates/site-header'
  elements:
    '.site-links': 'linksContainer'

  addNavLink: (href, label) ->
    a = @linksContainer.append '<a></a>'
    a.attr 'href', href

module.exports = SiteHeader
