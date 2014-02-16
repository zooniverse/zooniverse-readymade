Controller = require 'zooniverse/controllers/base-controller'
MarkingSurface = require 'marking-surface'

TOOLS =
  point: require 'marking-surface/lib/tools/magnifier-point' # TODO
  circle: null
  ellipse: require 'marking-surface/lib/tools/ellipse'
  rect: null
  polygon: null

loadImage = (src, callback) ->
  img = new Image
  img.onload = -> callback? img
  img.src = src

mod = (a, b) ->
  ((a % b) + b) % b

class SubjectViewer extends Controller
  className: 'subject-viewer'
  template: require './templates/subject-viewer'

  currentFrame: 0

  step: ''
  toolOptions: null

  elements:
    '.marking-surface-container': 'markingSurfaceContainer'
    'button[name="play-frames"]': 'playButton'
    'button[name="pause-frames"]': 'pauseButton'
    '.frame-toggles ul': 'togglesList'

  constructor: ->
    super

    @markingSurface = new MarkingSurface
    @markingSurfaceContainer.append @markingSurface.el

    @markingSurface.on 'create-mark', (mark) =>
      mark.set 'step', @step
      mark.set 'frame', @currentFrame

    @markingSurface.on 'create-tool', (tool) =>
      if @toolOptions?
        tool[property] = value for property, value of @toolOptions

    @frameGroup = @markingSurface.addShape 'g.frames'
    @frames = []

  loadSubject: (@subject, callback) ->
    @pauseFrames()

    @markingSurface.reset()
    @frames.pop().remove() until @frames.length is 0
    @togglesList.empty()

    widths = []
    heights = []

    subjectImages = [].concat @subject.location.standard
    for imgSrc, i in subjectImages then do (i) =>
      @addFrame imgSrc, (image) =>
        widths.push image.attr 'width'
        heights.push image.attr 'height'
        maxWidth = Math.max widths...
        maxHeight = Math.max heights...
        @markingSurface.el.style.width = "#{maxWidth}px"
        @frameGroup.attr transform: "translate(#{maxWidth / 2}, #{maxHeight / 2})"
        @markingSurface.svg.attr 'viewBox', " 0 0 #{maxWidth} #{maxHeight}"


        if i + 1 is subjectImages.length
          @goTo 0
          callback?()

      @addToggle i

    @playButton.prop 'disabled', subjectImages.length is 1
    @togglesList.find('button').prop 'disabled', subjectImages.length is 1

  addFrame: (imgSrc, callback) ->
    loadImage imgSrc, ({src, width, height}) =>
      image = @frameGroup.addShape 'image',
        'xlink:href': src
        width: width
        height: height
        x: width / -2
        y: height / -2

      @frames.push image
      callback? image

  addToggle: (index) ->
    @togglesList.append "<li><button name='toggle-frame', value='#{index}'>#{index}</button></li>"

  goTo: (@currentFrame) ->
    @currentFrame = mod @currentFrame, @frames.length

    @frames[@currentFrame].toFront()

    buttons = @togglesList.find 'button'
    buttons.attr 'data-selected', null
    buttons.eq(@currentFrame).attr 'data-selected', true

    @el.trigger 'change-frame', [@currentFrame]

  playFrames: ->
    @playButton.prop 'disabled', true
    @pauseButton.prop 'disabled', false
    # TODO

  pauseFrames: ->
    @playButton.prop 'disabled', false
    @pauseButton.prop 'disabled', true
    # TODO

  setStep: (step) ->
    @step = step

  setTool: (tool, options) ->
    if typeof tool is 'string'
      tool = TOOLS[tool]

    @markingSurface.tool = tool
    @toolOptions = options

  getMarks: ->
    marks = {}
    for mark in @markingSurface.marks
      marks[mark.step] ?= []
      marks[mark.step].push mark
    marks

  events:
    'click button[name="play-frames"]': ->
      @playFrames()

    'click button[name="pause-frames"]': ->
      @pauseFrames()

    'click button[name="toggle-frame"]': (e) ->
      @goTo e.currentTarget.value

module.exports = SubjectViewer
