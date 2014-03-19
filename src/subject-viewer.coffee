Controller = require 'zooniverse/controllers/base-controller'
MarkingSurface = require 'marking-surface'

loadImage = (src, callback) ->
  img = new Image
  img.onload = -> callback? img
  img.src = src

class SubjectViewer extends Controller
  className: 'readymade-subject-viewer'
  template: require './templates/subject-viewer'

  currentFrame: 0
  advanceTimeout: NaN

  taskIndex: -1
  toolOptions: null

  FROM_CURRENT_TASK: 'data-from-current-task'

  elements:
    '.readymade-marking-surface-container': 'markingSurfaceContainer'
    'button[name="play-frames"]': 'playButton'
    'button[name="pause-frames"]': 'pauseButton'
    '.readymade-frame-toggles-list': 'togglesList'

  constructor: ->
    super

    @createMarkingSurface()

  createMarkingSurface: ->
    @markingSurface = new MarkingSurface
    @frameGroup = @markingSurface.addShape 'g.frames'
    @frames = []

    @markingSurface.on 'add-tool', (tool) =>
      tool.attr @FROM_CURRENT_TASK, true
      color = @toolOptions?.color
      tool.el.style.color = color if color?
      tool.unit = @toolOptions.unit
      tool.upp = @toolOptions.upp
      tool.controls?.details = @toolOptions.details

      if @toolOptions?
        for property, value of @toolOptions
          tool[property] = value

      tool.mark.set '_taskIndex', @taskIndex
      tool.mark.set 'frame', @currentFrame


    @markingSurfaceContainer.append @markingSurface.el

  loadSubject: (@subject, callback) ->
    @pauseFrames()

    @markingSurface.reset()

    @frames.pop().remove() until @frames.length is 0

    @togglesList.empty()

    widths = []
    heights = []

    subjectImages = @subject.location.standard ? @subject.location
    subjectImages = [].concat subjectImages
    for imgSrc, i in subjectImages then do (i) =>
      @addFrame imgSrc, (image) =>
        widths.push image.attr 'width'
        heights.push image.attr 'height'
        maxWidth = Math.max widths...
        maxHeight = Math.max heights...

        @markingSurface.svg.attr
          # TODO: Figure out how to size the SVG.
          viewBox: "0 0 #{maxWidth} #{maxHeight}"

        @frameGroup.attr transform: "translate(#{maxWidth / 2}, #{maxHeight / 2})"

        if i + 1 is subjectImages.length
          @goTo 0
          callback?()

      @addToggle i

    @playButton.prop 'disabled', subjectImages.length is 1
    @togglesList.find('button').prop 'disabled', subjectImages.length is 1

  loadClassification: ->
    # TODO: For each annotation, figure out the right tools and draw any marks.

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
    @togglesList.append "<button name='toggle-frame' value='#{index}' class='toggle-frame'>#{index + 1}</button>\n"

  goTo: (@currentFrame) ->
    @currentFrame %%= @frames.length

    @frames[@currentFrame].toFront()

    buttons = @togglesList.find 'button'
    buttons.attr 'data-selected', null
    buttons.eq(@currentFrame).attr 'data-selected', true

    @el.trigger 'change-frame', [@currentFrame]

  playFrames: ->
    @playButton.prop 'disabled', true
    @pauseButton.prop 'disabled', false
    @advanceFrames()

  advanceFrames: ->
    @goTo @currentFrame + 1
    @advanceTimeout = setTimeout @advanceFrames.bind(@), 250

  pauseFrames: ->
    clearTimeout @advanceTimeout
    @playButton.prop 'disabled', false
    @pauseButton.prop 'disabled', true

  setTaskIndex: (@taskIndex) ->
    for tool in @markingSurface.tools by -1
      tool.attr @FROM_CURRENT_TASK, (tool.mark._taskIndex is @taskIndex) or null

  setTool: (tool, options) ->
    @markingSurface.tool = tool
    # Tool options will be applied to any newly-created tool.
    @toolOptions = options

  getMarks: ->
    marks = {}
    for {mark} in @markingSurface.tools
      marks[mark.step] ?= []
      marks[mark.step].push mark
    marks

  events:
    'click button[name="play-frames"]': ->
      @playFrames()
      @pauseButton.focus()

    'click button[name="pause-frames"]': ->
      @pauseFrames()
      @playButton.focus()

    'click button[name="toggle-frame"]': (e) ->
      @goTo e.currentTarget.value

module.exports = SubjectViewer
