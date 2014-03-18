Classifier = require './classifier'
SubjectViewer = require './subject-viewer'
DecisionTree = require 'zooniverse-decision-tree'
DrawingTask = require './tasks/drawing'
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'

class ClassifyPage extends Classifier
  tasks: null
  firstTask: ''

  className: "#{Classifier::className} readymade-classify-page"
  template: require './templates/classify-page'

  elements:
    '.readymade-subject-viewer-container': 'subjectViewerContainer'
    '.readymade-decision-tree-container': 'decisionTreeContainer'

  constructor: ->
    super
    @createSubjectViewer()
    @createDecisionTree()

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

  loadSubject: (subject, callback) ->
    super
    @subjectViewer.loadSubject subject, callback

  loadClassification: (classification) ->
    super
    @subjectViewer.loadClassification classification
    @decisionTree.reset classification

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
