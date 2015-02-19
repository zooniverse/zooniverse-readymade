Dialog = require 'zooniverse/controllers/dialog'
loginDialog = require 'zooniverse/controllers/login-dialog'
signupDialog = require 'zooniverse/controllers/signup-dialog'
Classifier = require './classifier'
MiniTutorial = require './mini-tutorial'
SubjectViewer = require './subject-viewer'
DecisionTree = require 'zooniverse-decision-tree'
ClassificationSummary = require './classification-summary'
DrawingTask = require './tasks/drawing'
FieldGuide = require './field-guide'
currentConfig = require 'zooniverse-readymade/current-configuration'
User = require 'zooniverse/models/user'
$ = window.jQuery
StackOfPages = require 'stack-of-pages'
Api = require 'zooniverse/lib/api'

class ClassifyPage extends Classifier
  START_TUTORIAL: "zooniverse-readymade:classifier:start_tutorial"

  targetSubjectID: ''

  workflow: 'untitled_workflow'
  tasks: null
  firstTask: ''

  tutorial: null
  tutorialSteps: null

  examples: null

  classificationsSubmitted: 0
  loginPromptEvery: 5 # Or use 0 to disable.

  className: "#{Classifier::className} readymade-classify-page"
  template: require './templates/classify-page'

  elements:
    '.readymade-no-more-subjects-message': 'noMoreSubjectsMessage'
    '.readymade-subject-viewer-container': 'subjectViewerContainer'
    '.readymade-decision-tree-container': 'decisionTreeContainer'
    '.readymade-summary-container': 'summaryContainer'
    '.readymade-field-guide-container': 'fieldGuideContainer'

  constructor: ->
    super

    if @tutorialSteps?
      @tutorial = new MiniTutorial steps: @tutorialSteps
      $(@tutorial.el).on @tutorial.CLOSE_EVENT, ->
        User.current?.setPreference 'tutorial_done', true

      @el.append @tutorial.el

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
      @subjectViewer.setTool null, null
      @subjectViewer.setTaskIndex e.detail.index
      @updateDrawingTask() if e.detail.task.type is 'drawing'

    @listenTo @decisionTree.el, DrawingTask::SELECT_TOOL, (e) =>
      # Delay so the default is preserved instead of cleared with the LOAD_TASK event.
      setTimeout =>
        {tool, choice} = e.detail
        @subjectViewer.setTool tool, choice

    @listenTo @decisionTree.el, @decisionTree.COMPLETE, =>
      @finishSubject()

    @decisionTreeContainer.append @decisionTree.el
    
    @listenTo @subjectViewer.markingSurface, 'marking-surface:add-tool', =>
      @updateDrawingTask()
      
    @listenTo @subjectViewer.markingSurface, 'marking-surface:remove-tool', =>
      @updateDrawingTask()

    @summary = new ClassificationSummary

    @summary.on @summary.DISMISS, =>
      @getNextSubject()

    @summaryContainer.append @summary.el

    if @examples?
      @fieldGuide = new FieldGuide {@examples}
      @fieldGuideContainer.append @fieldGuide.el

    @el.on StackOfPages::activateEvent, => @onActivate arguments...

  isUserScientist: ->
    result = new $.Deferred
    if User.current?
      # TODO: Cache some of this? Pretty nasty.
      project = Api.current.get "/projects/#{Api.current.project}"
      talkUser = Api.current.get "/projects/penguin/talk/users/#{User.current.name}"
      $.when(project, talkUser).then (project, talkUser) =>
        projectRoles = talkUser.talk?.roles?[project.id] ? []
        details =
          project: project.id
          roles: projectRoles
          scientist: 'scientist' in projectRoles
          admin: 'admin' in projectRoles
          'brian-c': talkUser.name in ['brian-c', 'eatyourgreens']
        console?.log 'Can you pick your own subject?', JSON.stringify details, null, 2
        result.resolve 'scientist' in projectRoles or 'admin' in projectRoles or talkUser.name in ['brian-c', 'eatyourgreens']
    else
      result.resolve false
    result.promise()

  onActivate: (e) ->
    @targetSubjectID = e.originalEvent.detail.subjectID
    if @targetSubjectID
      @getNextSubject() unless @targetSubjectID is @Subject.current?.zooniverse_id

  onUserChange: (user) ->
    super

    @classificationsSubmitted = 0

    if @tutorial?
      tutorialDone = user?.project?.tutorial_done
      tutorialDone ?= user?.preferences?[currentConfig.id]?.tutorial_done

      if tutorialDone
        if @tutorial.el.hasAttribute 'data-open'
          @tutorial.close()
      else
        @startTutorial()

  getNextSubject: ->
    if @targetSubjectID
      @isUserScientist().then (theyAre) =>
        if theyAre
          request = Api.current.get "/projects/#{Api.current.project}/subjects/#{@targetSubjectID}"
          request.then (data) =>
            subject = new @Subject data
            subject.select()
          request.fail =>
            alert "There's no subject with the ID #{@targetSubjectID}."
        else
          alert 'Sorry, only science team members can choose the subjects they classify.'
          super
    else
      super

  startTutorial: ->
    @tutorial.goTo 0
    @tutorial.open()
    @trigger @START_TUTORIAL, this, @tutorial

  onNoMoreSubjects: ->
    @noMoreSubjectsMessage.show()
    @subjectViewerContainer.hide()
    @decisionTreeContainer.hide()
    @summaryContainer.hide()

  createClassification: (subject) ->
    super
    if subject.zooniverse_id is @targetSubjectID
      @classification.set 'chosen_subject', true

  loadSubject: (subject, callback) ->
    args = arguments

    @noMoreSubjectsMessage.hide()
    @subjectViewerContainer.show()
    @decisionTreeContainer.show()
    @summaryContainer.hide()

    @subjectViewer.loadSubject subject, =>
      super args...

    @summary.loadSubject subject

  loadClassification: (classification, callback) ->
    args = arguments
    @decisionTree.reset() # TODO: Pass in a classification.
    @subjectViewer.loadClassification classification, =>
      super args...

  showSummary: ->
    @decisionTreeContainer.hide()
    @summaryContainer.show()
    @targetSubjectID = '' # Don't keep loading the same subject

  sendClassification: ->
    @classification.set 'workflow', @workflow
    for annotation in @composeAnnotations()
      @classification.annotate annotation
    super

    @classificationsSubmitted += 1

    unless User.current?
      if @classificationsSubmitted % @loginPromptEvery is 0
        @promptToLogIn()

  composeAnnotations: ->
    annotations = []

    decisionTreeValues = @decisionTree.getValues()
    for keyAndValue in decisionTreeValues then for key, value of keyAndValue
      annotations.push {key, value}

    annotations

  promptToLogIn: ->
    prompt = new Dialog
      warning: true

      content: """
        <header>You've submitted #{@classificationsSubmitted} classifications, but you're you're not logged in!</header>
        <p>Please sign in so we can make better use of your work and give you credit when the data is published.</p>
        <p class="action">
          <button name="close-dialog">No thanks</button>
          <button name="register">Register</button>
          <button name="sign-in">Sign in</button>
        </p>
      """

      events: $.extend {},
        Dialog::events
        'click button[name="register"]': ->
          @hide()
          signupDialog.show()

        'click button[name="sign-in"]': ->
          @hide()
          loginDialog.show()

      hide: ->
        Dialog::hide.call this
        setTimeout (=> @destroy()), 600

    prompt.show()
  
  updateDrawingTask: ->
    marks = []
    for {mark} in @subjectViewer.markingSurface.tools
      marks.push mark if mark._taskIndex is @subjectViewer.taskIndex
    
    @decisionTree.currentTask?.reset marks

  events:
    'change input[name="favorite"]': (e) ->
      @classification.favorite = e.target.checked

    'click button[name="restart-tutorial"]': ->
      @startTutorial()

module.exports = ClassifyPage
