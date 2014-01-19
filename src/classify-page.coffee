Controller = require 'zooniverse/controllers/base-controller'
SubjectViewer = require './subject-viewer'
DecisionTree = require './decision-tree'
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'

class ClassifyPage extends Controller
  className: 'classify-page'
  template: require './templates/classify-page'

  elements:
    '.classification-interface': 'interfaceContainer'
  constructor: (@steps) ->
    super null

    @subjectViewer = new SubjectViewer
    @interfaceContainer.append @subjectViewer.el

    @decisionTree = new DecisionTree @steps
    @interfaceContainer.append @decisionTree.el

    @decisionTree.on 'select-tool', (e, tool, options) =>
      @subjectViewer.setTool tool, options

    @decisionTree.on 'finished-all-steps', (e) =>
      @onFinished()

    User.on 'change', (e, user) =>
      @onUserChange user

    Subject.on 'select', (e, subject) =>
      @onSelectSubject subject

    if +location.port > 1023
      window.classifyPage = @

  onUserChange: (user) ->
    Subject.next()

  onSelectSubject: (subject) ->
    @classification = new Classification {subject}
    @subjectViewer.loadSubject subject
    @decisionTree.goTo @decisionTree.firstStep

  onFinished: ->
    Subject.next()

    # Send classification
    # Load next subject

module.exports = ClassifyPage
