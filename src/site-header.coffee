Controller = window.zooniverse?.controllers?.BaseController or require('zooniverse/controllers/base-controller')

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
    link = document.createElement 'a'
    link.href = href
    link.innerHTML = label
    link.className = 'readymade-site-link'
    
    li = document.createElement 'li'
    li.appendChild link
    
    @linksList.append li
  
    link

  onHashChange: =>
    unless window.location.hash == '' || window.location.hash[0..1] == '#/'
      panel = document.querySelector window.location.hash
      e = new CustomEvent 'activate-in-stack'
      panel?.dispatchEvent e

module.exports = SiteHeader
