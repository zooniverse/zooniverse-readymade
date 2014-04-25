Controller = require 'zooniverse/controllers/base-controller'
$ = window.jQuery

class SiteHeader extends Controller
  className: 'readymade-site-header'
  template: require './templates/site-header'
  elements:
    '.readymade-site-links': 'linksList'

  constructor: ->
    super
    addEventListener 'hashchange', @onHashChange
    setTimeout @onHashChange

  addNavLink: (href, label) ->
    @linksList.append "<a href='#{href}' class='readymade-site-link'>#{label}</a>\n"

  onHashChange: =>
    for link in @linksList.find 'a'
      href = link.getAttribute 'href'
      match = if href.length is 2 # Probably only "#/"
        location.hash is href
      else
        location.hash.indexOf(href) is 0

      $(link).toggleClass 'active', match

module.exports = SiteHeader
