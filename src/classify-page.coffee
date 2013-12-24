Controller = require 'zooniverse/controllers/base-controller'
SubjectViewer = require './subject-viewer'
DecisionTree = require './decision-tree'
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'

class ClassifyPage extends Controller
  constructor: ->
    super

    @subjectViewer = new SubjectViewer
    @el.append @subjectViewer.el

    @decisionTree = new DecisionTree
    @el.append @decisionTree.el

    User.on 'change', (e, user) =>
      @onUserChange user

    Subject.on 'select', (e, subject) =>
      @onSelectSubject subject

  onUserChange: (user) ->
    Subject.next()

  onSelectSubject: (subject) ->
    @classification = new Classification {subject}
    # @subjectViewer.subject = subject
    # @decisionTree.classification = subject

module.exports = ClassifyPage
