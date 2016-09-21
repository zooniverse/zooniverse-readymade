flags = require './lib/flags'
Controller = window.zooniverse?.controllers?.BaseController or require('zooniverse/controllers/base-controller')
User = window.zooniverse?.models?.User or require('zooniverse/models/user')
Subject = window.zooniverse?.models?.Subject or require('zooniverse/models/subject')
Classification = window.zooniverse?.models?.Classification or require('zooniverse/models/classification')

IS_DEV = if flags.dev?
  flags.dev is 1
else
  +location.port > 1023

class Classifier extends Controller
  CREATE: "zooniverse-readymade:classifier:create"
  LOAD_SUBJECT: "zooniverse-readymade:classifier:load_subject"
  LOAD_CLASSIFICATION: "zooniverse-readymade:classifier:load_classification"
  CREATE_CLASSIFICATION: "zooniverse-readymade:classifier:create_classification"
  FINISH_SUBJECT: "zooniverse-readymade:classifier:finish_subject"
  SEND_CLASSIFICATION: "zooniverse-readymade:classifier:send_classification"

  Subject: null
  subjectGroup: Subject::subjectGroup

  className: 'readymade-classifier'

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

    @listenTo @Subject, 'no-more', (e) =>
      @onNoMoreSubjects()

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
    unless @classification?
      @getNextSubject()

  onSubjectGettingNext: ->
    @el.addClass 'readymade-loading'
    @classification = null

  onNoMoreSubjects: ->
    # Override me.

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
    @showSummary()
    @trigger @FINISH_SUBJECT, this, @classification

  sendClassification: ->
    @classification.send() unless IS_DEV
    console?.log JSON.stringify(@classification) + if IS_DEV then '(Not sent)' else ''
    @trigger @SEND_CLASSIFICATION, this, @classification

  showSummary: ->
    # NOTE: Override this to show a post-classification summary.
    @getNextSubject()

  getNextSubject: ->
    @Subject.next()

module.exports = Classifier
