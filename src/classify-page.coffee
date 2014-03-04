Controller = require 'zooniverse/controllers/base-controller'
SubjectViewer = require './subject-viewer'
DecisionTree = require 'zooniverse-decision-tree'
DrawingTask = require './tasks/drawing'
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'

class ClassifyPage extends Controller
  stepSpecs: null
  firstStep: ''

  className: 'readymade-classify-page'
  template: require './templates/classify-page'

  elements:
    '.readymade-classification-interface': 'interfaceContainer'

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
    @interfaceContainer.append @subjectViewer.el

  createDecisionTree: ->
    @decisionTree = new DecisionTree
      taskTypes:
        radio: require './tasks/radio'
        checkbox: require './tasks/checkbox'
        button: require './tasks/button'
        drawing: DrawingTask
      tasks: @stepSpecs
      firstTask: @firstStep

    @el.on @decisionTree.LOAD_TASK, ({originalEvent: e}) =>
      @subjectViewer.setTaskIndex e.detail.index

    @el.on DrawingTask::SELECT_TOOL, ({originalEvent: e}) =>
      {tool, choice} = e.detail
      @subjectViewer.setTool tool, choice

    @el.on @decisionTree.COMPLETE, =>
      @finishSubject()

    @interfaceContainer.append @decisionTree.el

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
    # @classification.set 'marks', @subjectViewer.getMarks()
    console?.log JSON.stringify @classification
    Subject.next()

  composeClassification: ->
    annotations = @decisionTree.getValues()

    for {mark} in @subjectViewer.markingSurface.tools
      annotations[mark._taskIndex]._marks ?= []
      annotations[mark._taskIndex]._marks.push mark

    annotations

module.exports = ClassifyPage
