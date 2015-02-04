Api = require 'zooniverse/lib/api'
TopBar = require 'zooniverse/controllers/top-bar'
SiteBackground = require './site-background'
SiteHeader = require './site-header'
StackOfPages = require 'stack-of-pages'
translate = require 'zooniverse/lib/translate'
homePageTemplate = require './templates/home-page'
ZooniverseFooter = require 'zooniverse/controllers/footer'
dash = require './lib/dash'
ClassifyPage = require './classify-page'
Profile = require 'zooniverse/controllers/profile'
teamPageTemplate = require './templates/team-page'
User = require 'zooniverse/models/user'
TabSet = require './tab-control'

class Project
  parent: document.body

  background: ''
  id: ''

  producer: ''
  title: ''
  summary: ''
  description: ''

  about: ''
  pages: null

  workflows: null

  # If there's only one workflow, just define tasks.
  tasks: null
  firstTask: ''
  subjectGroup: false

  organizations: null
  scientists: null
  developers: null

  constructor: (configuration = {}) ->
    for property, value of configuration
      @[property] = value

    if @background
      @siteBackground = new SiteBackground
        src: @background
        el: '#site-background'

    if @id
      @connect @id

    @header = new SiteHeader
      el: '#main-header'
      template: SiteHeader::template @

    @stack = new StackOfPages 
      el: document.getElementById 'main-content'
      changeDisplay: false
      
    @stack.el.className += ' readymade-main-stack'

    if @summary or @description
      @homePage = @addPage '#/', translate('readymade.home'), homePageTemplate @

      unless @footer is false
        footer = new ZooniverseFooter
        footer.el.appendTo '#main-footer'

    @classifyPages = []

    if @workflows?
      for {key, label, subjectGroup, tasks, firstTask, tutorialSteps, examples} in @workflows
        label ?= translate 'readymade.classify'
        key ?= dash(label).replace /\-/g, '_'

        page = new ClassifyPage
          subjectGroup: subjectGroup ? @subjectGroup
          workflow: key
          tasks: tasks
          firstTask: firstTask
          tutorialSteps: tutorialSteps
          examples: examples

        @addPage "#/#{dash label}/:subjectID", label, page
        @classifyPages.push page

    else if @tasks?
      page = new ClassifyPage {@tasks, @firstTask, @subjectGroup, @tutorialSteps, @examples}
      @addPage '#/classify/:subjectID', translate('readymade.classify'), page
      @classifyPages.push page

    unless @profile is false
      @profile = new Profile
      @addPage '#/profile', translate('readymade.profile'), @profile

    if @pages?
      for page in @pages
        for title, content of page
          if content instanceof Array
            newContent = @makeStackFromPages content, [dash title]
          else if typeof content is 'string'
            newContent = """
              <div class='readymade-generic-page' data-readymade-page='#{dash title}'>#{content}</div>
            """
          else
            newContent = content

          hash = "#/#{dash title}"
          @addPage hash, title, newContent

    if @organizations or @scientists or @developers
      @addPage '#/team', translate('readymade.team'), teamPageTemplate @

    @buildNavTabs @header.linksList, 'nav'
    
    if @externalLinks?
      for title, href of @externalLinks
        @header.addNavLink href, title

    setTimeout => @stack.onHashChange()

    User.fetch()

  makeStackFromPages: (pages, currentPath = []) ->
    mapOfHashes = { changeDisplay: false }
    prefix = currentPath[ currentPath.length - 1 ]

    nav = document.createElement 'nav'
    nav.className = 'readymade-subnav'

    for description, i in pages
      for title, content of description
        id = dash title
        currentPath.push id

        hash = ['#', currentPath...].join '/'
        mapOfHashes.default ?= hash
      
        nav.appendChild @navLink id, hash, title
      
        mapOfHashes[hash] = if content instanceof Array
          @makeStackFromPages content, currentPath
        else if typeof content is 'string'
          """
            <div id='#{id}' class='readymade-generic-page' data-readymade-page='#{dash title}'>#{content}</div>
          """
        else
          container = document.createElement 'div'
          # TODO: Add sub-navigation.
          content

        currentPath.pop()

    stack = new StackOfPages mapOfHashes
    stack.el.insertBefore nav, stack.el.firstChild
    setTimeout -> stack.onHashChange()
    @buildNavTabs nav, prefix, stack
    stack

  connect: (project) ->
    @api = new Api {project}
    @topBar = new TopBar el: '#top-bar'

  addPage: (href, label, content) ->
    linkHREF = href.replace /\/:[^\/]+/g, ''
    
    frag_id = linkHREF.split('/').pop()
    frag_id = 'home' if frag_id == ''
    
    if content instanceof StackOfPages
      href += "/*"
    
    @stack.add href, content
    page = @stack.el.children[@stack.el.children.length - 1]
    page.id = frag_id
    
    link = @header.addNavLink '#' + frag_id, label
    link.addEventListener 'click', (e) ->
      window.location.hash = linkHREF
      e.preventDefault()

    page
  
  navLink: (id, hash, title) ->
    link = document.createElement 'a'
    link.href = '#' + id
    link.innerHTML  = title
    link.addEventListener 'click', (e) =>
      e.preventDefault()
      window.location.hash = hash
  
    link
  
  buildNavTabs: (nav, prefix, stack = @stack) ->
    nav_links = []
    panels = []
  
    nav = nav[0] if nav[0]?
    for link in nav.querySelectorAll 'a'
      hash = link.getAttribute 'href'
      panel = stack.el.querySelector hash
      if panel?
        panels.push panel
        nav_links.push link
  
    @buildTabset nav_links, panels, prefix, stack
  
  buildTabset: (tabs, panels, prefix, stack) ->
    tabset = new TabSet
    for tab, i in tabs
      panel = panels[i]
      tab.id = prefix + '-tab-' + i if tab.id == ''
      panel.id = prefix + '-' + i if panel.id == ''
      tabset.add tab, panel, panel.hasAttribute stack.activatedAttr
    
      do (panel)->
        panel.addEventListener stack.activateEvent, (e) ->
          e.stopPropagation()
          tabset.activate panel

module.exports = Project
