Controller = require 'zooniverse/controllers/base-controller'
SubjectViewer = require './subject-viewer'
DecisionTree = require 'zooniverse-decision-tree'
DrawingTask = require './tasks/drawing'
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'

class ClassifyPage extends Controller
  tasks: null
  firstTask: ''

  className: 'readymade-classify-page'
  template: require './templates/classify-page'

  elements:
    '.readymade-subject-viewer-container': 'subjectViewerContainer'
    '.readymade-decision-tree-container': 'decisionTreeContainer'

  constructor: ->
    super

    @createSubjectViewer()
    @createDecisionTree()

    User.on 'change', (e, user) =>
      @onUserChange user

    Subject.on 'getting-next', =>
      @onSubjectGettingNext()

    Subject.on 'select', (e, subject) =>
      @onSubjectSelect subject

    if +location.port > 1023
      window.classifyPage = @

  createSubjectViewer: ->
    @subjectViewer = new SubjectViewer
    @subjectViewerContainer.append @subjectViewer.el

  createDecisionTree: ->
    @decisionTree = new DecisionTree
      taskTypes:
        radio: require './tasks/radio'
        checkbox: require './tasks/checkbox'
        button: require './tasks/button'
        drawing: DrawingTask
      tasks: @tasks
      firstTask: @firstTask || Object.keys(@tasks)[0]

    @el.on @decisionTree.LOAD_TASK, ({originalEvent: e}) =>
      @subjectViewer.setTaskIndex e.detail.index

    @el.on DrawingTask::SELECT_TOOL, ({originalEvent: e}) =>
      {tool, choice} = e.detail
      @subjectViewer.setTool tool, choice

    @el.on @decisionTree.COMPLETE, =>
      @finishSubject()

    @decisionTreeContainer.append @decisionTree.el

  onUserChange: (user) ->
    @loadSubject() unless @classification?

  onSubjectGettingNext: ->
    @el.addClass 'loading'

  onSubjectSelect: (subject) ->
    @classification = new Classification {subject}
    @loadSubject subject, null, =>
      @el.removeClass 'loading'

  loadSubject: (subject, classification, callback) ->
    if subject?
      @subjectViewer.loadSubject subject, classification, callback
      @decisionTree.reset classification
    else
      Subject.next()

  finishSubject: ->
    for annotation in @composeClassification()
      @classification.annotate annotation
    console?.log JSON.stringify @classification
    Subject.next()

  composeClassification: ->
    annotations = []

    decisionTreeValues = @decisionTree.getValues()
    for keyAndValue in decisionTreeValues then for key, value of keyAndValue
      annotations.push {key, value}

    for {mark} in @subjectViewer.markingSurface.tools
      annotations[mark._taskIndex].marks ?= []
      annotations[mark._taskIndex].marks.push mark

    annotations

module.exports = ClassifyPage
