Api = require 'zooniverse/lib/api'
TopBar = require 'zooniverse/controllers/top-bar'
SiteHeader = require './site-header'
StackOfPages = require 'stack-of-pages'
homePageTemplate = require './templates/home-page'
teamPageTemplate = require './templates/team-page'

class Project
  parent: document.body

  constructor: (setup = {}) ->
    @parent = setup.parent if 'parent' of setup

    @connect setup.projectId

    @header = new SiteHeader
      template: SiteHeader::template setup

    @stack = new StackOfPages {}

    if setup.producer? or setup.title? or setup.summary? or setup.description?
      @addHomePage setup

    if setup.organizations? or setup.scientists? or setup.developers?
      @addTeamPage setup

    @header.el.appendTo @parent if @parent?
    @parent?.appendChild @stack.el

    @stack.onHashChange()

    if +location.port > 1023
      window.zooniverseReadymadeProject = @

  connect: (project) ->
    @api = new Api {project}
    @topBar = new TopBar
    @topBar.el.appendTo document.body

  addHomePage: (setup) ->
    @stack.add '#/', homePageTemplate setup
    @header.addNavLink '#/', 'Home'

  addTeamPage: (setup)->
    @stack.add '#/team', teamPageTemplate setup
    @header.addNavLink '#/team', 'Team'

module.exports = Project
