Controller = require 'zooniverse/controllers/base-controller'
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'

IS_DEV = +location.port > 1023

class Classifier extends Controller
  className: 'readymade-classifier'

  tutorial: null

  constructor: ->
    super

    @listenTo User, 'change', (e, user) =>
      @onUserChange user

    @listenTo Subject, 'getting-next', =>
      @onSubjectGettingNext()

    @listenTo Subject, 'select', (e, subject) =>
      @onSubjectSelect subject

    if IS_DEV
      window.classifier = this

  # TODO: This should totally be built in.
  listenTo: (thing, eventName, handler) ->
    addEvent = if 'on' of thing then 'on' else 'addEventListener'
    removeEvent = if 'off' of thing then 'off' else 'removeEventListener'

    thing[addEvent] eventName, handler

    @on 'destroy', ->
      thing[removeEvent] eventName, handler

  onUserChange: (user) ->
    tutorialDone = user?.project?.tutorial_done

    if @tutorial? and not tutorialDone
      @startTutorial()
    else
      unless @classification?
        Subject.next()

  startTutorial: ->
    # TODO: How should we define and select the tutorial subject?
    @tutorial.start()

  onSubjectGettingNext: ->
    @el.addClass 'readymade-loading'
    @classification = null

  onSubjectSelect: (subject) ->
    @createClassification subject
    @loadSubject subject, =>
      @loadClassification @classification
      @el.removeClass 'readymade-loading'

  createClassification: (subject) ->
    @classification = new Classification {subject}

  loadSubject: (subject, callback) ->
    # Do whatever you want here.

  loadClassification: (classification) ->
    # Do whatever you want here.

  finishSubject: ->
    @sendClassification()
    @getNextSubject()

  sendClassification: ->
    # @classification.send()
    console?.log JSON.stringify @classification if IS_DEV

  getNextSubject: ->
    Subject.next()

module.exports = Classifier
