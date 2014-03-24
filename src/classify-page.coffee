Classifier = require './classifier'
SubjectViewer = require './subject-viewer'
DecisionTree = require 'zooniverse-decision-tree'
DrawingTask = require './tasks/drawing'

class ClassifyPage extends Classifier
  workflow: 'untitled_workflow'
  tasks: null
  firstTask: ''

  className: "#{Classifier::className} readymade-classify-page"
  template: require './templates/classify-page'

  elements:
    '.readymade-subject-viewer-container': 'subjectViewerContainer'
    '.readymade-decision-tree-container': 'decisionTreeContainer'

  constructor: ->
    super

    @subjectViewer = new SubjectViewer
    @subjectViewerContainer.append @subjectViewer.el

    @decisionTree = new DecisionTree
      taskTypes:
        radio: require './tasks/radio'
        checkbox: require './tasks/checkbox'
        button: require './tasks/button'
        filter: require './tasks/filter'
        drawing: DrawingTask
      tasks: @tasks
      firstTask: @firstTask || Object.keys(@tasks)[0]

    @listenTo @decisionTree.el, @decisionTree.LOAD_TASK, (e) =>
      @subjectViewer.setTaskIndex e.detail.index

    @listenTo @decisionTree.el, DrawingTask::SELECT_TOOL, (e) =>
      {tool, choice} = e.detail
      @subjectViewer.setTool tool, choice

    @listenTo @decisionTree.el, @decisionTree.COMPLETE, =>
      @finishSubject()

    @decisionTreeContainer.append @decisionTree.el

  loadSubject: (subject, callback) ->
    super
    @subjectViewer.loadSubject subject, callback

  loadClassification: (classification) ->
    super
    @subjectViewer.loadClassification classification
    @decisionTree.reset() # TODO: Pass in a classification.

  sendClassification: ->
    @classification.set 'workflow', @workflow
    for annotation in @composeAnnotations()
      @classification.annotate annotation
    super

  composeAnnotations: ->
    annotations = []

    decisionTreeValues = @decisionTree.getValues()
    for keyAndValue in decisionTreeValues then for key, value of keyAndValue
      annotations.push {key, value}

    for {mark} in @subjectViewer.markingSurface.tools
      annotations[mark._taskIndex].marks ?= []
      annotations[mark._taskIndex].marks.push mark

    annotations

module.exports = ClassifyPage
