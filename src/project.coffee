Api = require 'zooniverse/lib/api'
TopBar = require 'zooniverse/controllers/top-bar'
SiteBackground = require './site-background'
SiteHeader = require './site-header'
StackOfPages = require 'stack-of-pages'
homePageTemplate = require './templates/home-page'
ZooniverseFooter = require 'zooniverse/controllers/footer'
dash = require './lib/dash'
ClassifyPage = require './classify-page'
Profile = require 'zooniverse/controllers/profile'
teamPageTemplate = require './templates/team-page'
User = require 'zooniverse/models/user'

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

    @stack = new StackOfPages el: document.getElementById 'main-content'
    @stack.el.className += ' readymade-main-stack'

    if @summary or @description
      @homePage = @addPage '#/', 'Home', homePageTemplate @

      unless @footer is false
        footer = new ZooniverseFooter
        footer.el.appendTo '#main-footer'

    @classifyPages = []

    if @workflows?
      for {key, label, subjectGroup, tasks, firstTask, tutorialSteps, examples} in @workflows
        label ?= 'Classify'
        key ?= dash(label).replace /\-/g, '_'

        page = new ClassifyPage
          subjectGroup: subjectGroup ? @subjectGroup
          workflow: key
          tasks: tasks
          firstTask: firstTask
          tutorialSteps: tutorialSteps
          examples: examples

        @addPage "#/#{dash label}", label, page
        @classifyPages.push page

    else if @tasks?
      page = new ClassifyPage {@tasks, @firstTask, @subjectGroup, @tutorialSteps, @examples}
      @addPage '#/classify', 'Classify', page
      @classifyPages.push page

    unless @profile is false
      @profile = new Profile
      @addPage '#/profile', 'Profile', @profile

    if @pages?
      for page in @pages
        for title, content of page
          if content instanceof Array
            newContent = @makeStackFromPages content, [dash title]
          else
            newContent = """
              <div class='readymade-generic-page' data-readymade-page='#{dash title}'>#{content}</div>
            """

          hash = "#/#{dash title}"
          @addPage hash, title, newContent

    if @organizations or @scientists or @developers
      @addPage '#/team', 'Team', teamPageTemplate @

    if @externalLinks?
      for title, href of @externalLinks
        @header.addNavLink href, title

    setTimeout => @stack.onHashChange()

    User.fetch()

  makeStackFromPages: (pages, currentPath = []) ->
    mapOfHashes = {}

    nav = document.createElement 'nav'
    nav.className = 'readymade-subnav'

    for description, i in pages
      for title, content of description
        currentPath.push dash title

        hash = ['#', currentPath...].join '/'
        mapOfHashes.default ?= hash

        nav.insertAdjacentHTML 'beforeEnd', """
          <a href="#{hash}">#{title}</a>
        """

        mapOfHashes[hash] = if content instanceof Array
          @makeStackFromPages content, currentPath
        else if typeof content is 'string'
          """
            <div class='readymade-generic-page' data-readymade-page='#{dash title}'>#{content}</div>
          """
        else
          container = document.createElement 'div'
          # TODO: Add sub-navigation.
          content

        currentPath.pop()

    stack = new StackOfPages mapOfHashes
    stack.el.insertAdjacentHTML 'afterBegin', nav.outerHTML
    setTimeout -> stack.onHashChange()
    stack

  connect: (project) ->
    @api = new Api {project}
    @topBar = new TopBar el: '#top-bar'

  addPage: (href, label, content) ->
    @header.addNavLink href, label

    if content instanceof StackOfPages
      href += "/*"

    @stack.add href, content
    @stack.el.children[@stack.el.children.length - 1]

module.exports = Project
