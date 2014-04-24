Api = require 'zooniverse/lib/api'
TopBar = require 'zooniverse/controllers/top-bar'
SiteBackground = require './site-background'
SiteHeader = require './site-header'
StackOfPages = require 'stack-of-pages'
homePageTemplate = require './templates/home-page'
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

  organizations: null
  scientists: null
  developers: null

  constructor: (configuration = {}) ->
    for property, value of configuration
      @[property] = value

    if @background
      @siteBackground = new SiteBackground src: @background
      @siteBackground.el.appendTo document.body

    if @id
      @connect @id

    @header = new SiteHeader
      template: SiteHeader::template @

    @stack = new StackOfPages
    @stack.el.className += ' readymade-main-stack'

    if @summary or @description
      @addPage '#/', 'Home', homePageTemplate @

    @classifyPages = []

    if @workflows?
      for {key, label, subjectGroup, tasks, firstTask} in @workflows
        label ?= 'Classify'
        key ?= dash(label).replace /\-/g, '_'

        page = new ClassifyPage
          subjectGroup: subjectGroup
          workflow: key
          tasks: tasks
          firstTask: firstTask

        @addPage "#/#{dash label}", label, page
        @classifyPages.push page

    else if @tasks?
      page = new ClassifyPage {@tasks, @firstTask}
      @addPage '#/classify', 'Classify', page
      @classifyPages.push page

    unless @profile is false
      @profile = new Profile
      @addPage '#/profile', 'Profile', @profile

    if @pages?
      for page in @pages
        # TODO: What about translating links to these pages?
        for title, content of page
          @addPage "#/#{dash title}", title, "<div>#{content}</div>"

    if @organizations or @scientists or @developers
      @addPage '#/team', 'Team', teamPageTemplate @

    @header.el.appendTo @parent if @parent?
    @parent?.appendChild @stack.el

    @stack.onHashChange()

    User.fetch()

  connect: (project) ->
    @api = new Api {project}
    @topBar = new TopBar
    @topBar.el.appendTo document.body

  addPage: (href, label, content) ->
    @stack.add href, content
    @header.addNavLink href, label

module.exports = Project
