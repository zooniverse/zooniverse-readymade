Controller = require 'zooniverse/controllers/base-controller'
TabSet = require './tab-control'
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
    link = document.createElement 'a'
    link.href = href
    link.textContent = label
    link.className = 'readymade-site-link'
    
    li = document.createElement li
  
    @linksList.append li.appendChild link
  
    link

  onHashChange: =>
    unless window.location.hash == '' || window.location.hash[0..1] == '#/'
      panel = document.querySelector window.location.hash
      e = new CustomEvent 'activate-in-stack'
      panel?.dispatchEvent e

  buildTabset: (tabs, panels, prefix, stack)->
    tabset = new TabSet
    for tab, i in tabs
      panel = panels[i]
      tab.id = prefix + '-tab-' + i if tab.id == ''
      panel.id = prefix + '-' + i if panel.id == ''
      tabset.add tab, panel, panel.hasAttribute stack.activatedAttr
    
      do (panel)->
        panel.addEventListener 'activate-in-stack', (e) ->
          e.stopPropagation()
          tabset.activate panel
    
      subnav = panel.querySelector '.readymade-subnav'
      @buildNav stack, subnav, panel.id if subnav?

  buildNav: (stack, nav = @linksList, prefix = 'nav')->
    nav_links = []
    panels = []
  
    nav = nav[0] if nav[0]?
    for link in nav.querySelectorAll 'a'
      hash = link.getAttribute 'href'
      panel = document.querySelector hash
      if panel?
        panels.push panel
        nav_links.push link
  
    @buildTabset nav_links, panels, prefix, stack

module.exports = SiteHeader
