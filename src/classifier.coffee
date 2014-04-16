Controller = require 'zooniverse/controllers/base-controller'
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'

IS_DEV = +location.port > 1023

class Classifier extends Controller
  CREATE: "zooniverse-readymade:classifier:create"
  START_TUTORIAL: "zooniverse-readymade:classifier:start_tutorial"
  LOAD_SUBJECT: "zooniverse-readymade:classifier:load_subject"
  LOAD_CLASSIFICATION: "zooniverse-readymade:classifier:load_classification"
  CREATE_CLASSIFICATION: "zooniverse-readymade:classifier:create_classification"
  FINISH_SUBJECT: "zooniverse-readymade:classifier:finish_subject"
  SEND_CLASSIFICATION: "zooniverse-readymade:classifier:send_classification"

  Subject: null
  subjectGroup: Subject::subjectGroup

  className: 'readymade-classifier'

  tutorial: null

  constructor: ->
    @Subject = class extends Subject

    super

    @Subject.group = @subjectGroup

    @listenTo User, 'change', (e, user) =>
      @onUserChange user

    @listenTo @Subject, 'getting-next', =>
      @onSubjectGettingNext()

    @listenTo @Subject, 'select', (e, subject) =>
      @onSubjectSelect subject

    if IS_DEV
      window.classifier = this

    @trigger @CREATE, this

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
        @Subject.next()

  startTutorial: ->
    # TODO: How should we define and select the tutorial subject?
    @tutorial.start()
    @trigger @START_TUTORIAL, this, @tutorial

  onSubjectGettingNext: ->
    @el.addClass 'readymade-loading'
    @classification = null

  onSubjectSelect: (subject) ->
    @createClassification subject
    @loadSubject subject, (subject) =>
      @loadClassification @classification, (classification) =>
        @el.removeClass 'readymade-loading'

  createClassification: (subject) ->
    @classification = new Classification {subject}
    @trigger @CREATE_CLASSIFICATION, this, @classification

  loadSubject: (subject, callback) ->
    # Do whatever you want here, just make sure you call the callback.
    callback? subject
    @trigger @LOAD_SUBJECT, [subject]

  loadClassification: (classification, callback) ->
    # Do whatever you want here, just make sure you call the callback.
    callback? classification
    @trigger @LOAD_CLASSIFICATION, this, classification

  finishSubject: ->
    @sendClassification()
    @getNextSubject()
    @trigger @FINISH_SUBJECT, this, @classification

  sendClassification: ->
    # @classification.send()
    console?.log JSON.stringify @classification if IS_DEV
    @trigger @SEND_CLASSIFICATION, this, @classification

  getNextSubject: ->
    @Subject.next()

module.exports = Classifier
