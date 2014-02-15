Controller = require 'zooniverse/controllers/base-controller'
SubjectViewer = require './subject-viewer'
DecisionTree = require './decision-tree'
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'

class ClassifyPage extends Controller
  steps: null
  firstStep: ''

  className: 'classify-page'
  template: require './templates/classify-page'

  elements:
    '.classification-interface': 'interfaceContainer'

  constructor: ->
    super

    @subjectViewer = new SubjectViewer
    @interfaceContainer.append @subjectViewer.el

    @decisionTree = new DecisionTree {@steps, @firstStep}
    @interfaceContainer.append @decisionTree.el

    @decisionTree.on 'change-step', (e, step) =>
      @subjectViewer.setTool null
      @subjectViewer.setStep step

    User.on 'change', (e, user) =>
      @onUserChange user

    Subject.on 'getting-next', (e, subject) =>
      @onSubjectGettingNext()

    Subject.on 'select', (e, subject) =>
      @onSubjectSelect subject

    if +location.port > 1023
      window.classifyPage = @

  onUserChange: (user) ->
    Subject.next()

  onSubjectGettingNext: ->
    @el.addClass 'loading'

  onSubjectSelect: (subject) ->
    @classification = new Classification {subject}
    @decisionTree.reset()
    @subjectViewer.loadSubject subject, =>
      @el.removeClass 'loading'

  finishSubject: ->
    @classification.set 'marks', @subjectViewer.getMarks()
    console.log JSON.stringify @classification
    Subject.next()

  events:
    'change-annotation': (e, key, value) ->
      @classification.set key, value

    'select-tool': (e, tool, step) ->
      @subjectViewer.setTool tool, step

    'finished-all-steps': ->
      @finishSubject()

module.exports = ClassifyPage
