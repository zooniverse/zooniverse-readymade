Controller = require 'zooniverse/controllers/base-controller'
MarkingSurface = require 'marking-surface'
loadImage = require './lib/load-image'

class SubjectViewer extends Controller
  className: 'readymade-subject-viewer'
  template: require './templates/subject-viewer'

  currentFrame: 0
  advanceTimeout: NaN

  maxWidth: 0
  maxHeight: 0

  taskIndex: -1
  toolOptions: null

  FROM_CURRENT_TASK: 'data-from-current-task'

  elements:
    'input[name="hide-old-marks"]': 'oldMarksToggle'
    '.readymade-marking-surface-container': 'markingSurfaceContainer'
    '.readymade-frame-controls': 'frameControls'
    'button[name="play-frames"]': 'playButton'
    'button[name="pause-frames"]': 'pauseButton'
    '.readymade-frame-toggles-list': 'togglesList'

  constructor: ->
    super

    @createMarkingSurface()
    addEventListener 'resize', @rescale
    addEventListener 'hashchange', @rescale

  createMarkingSurface: ->
    @markingSurface = new MarkingSurface
      focusable: false
    @markingSurface.svg.attr
      preserveAspectRatio: 'xMidYMid meet'
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
      tool.mark.set 'value', @toolOptions.value if @toolOptions.value?
      tool.mark.set 'frame', @currentFrame

    @markingSurfaceContainer.append @markingSurface.el

  rescale: =>
    maxPhysicalWidth = @markingSurface.el.parentNode.offsetWidth
    maxPhysicalHeight = Math.min innerHeight - 10

    scale = Math.min maxPhysicalWidth / @maxWidth, maxPhysicalHeight / @maxHeight

    @markingSurface.svg.attr
      width: scale * @maxWidth
      height: scale * @maxHeight

  loadSubject: (@subject, callback) ->
    @pauseFrames()

    @markingSurface.reset()
    @frames.pop().remove() until @frames.length is 0
    @togglesList.empty()

    subjectImages = [].concat @subject.location.standard ? @subject.location

    widths = []
    heights = []

    for imgSrc, i in subjectImages then do (i) =>
      @addFrame imgSrc, (image) =>
        widths.push image.attr 'width'
        heights.push image.attr 'height'
        @maxWidth = Math.max widths...
        @maxHeight = Math.max heights...

        @markingSurface.svg.attr
          # TODO: Figure out how to size the SVG.
          viewBox: "0 0 #{@maxWidth} #{@maxHeight}"

        @frameGroup.attr transform: "translate(#{@maxWidth / 2}, #{@maxHeight / 2})"

        @rescale()

        if i + 1 is subjectImages.length
          @goTo 0
          callback?()

      @addToggle i

    @frameControls.attr 'data-single-frame', (subjectImages.length is 1) || null
    # @playButton.prop 'disabled', subjectImages.length is 1
    # @togglesList.find('button').prop 'disabled', subjectImages.length is 1

  loadClassification: (classification, callback) ->
    # TODO: For each annotation, figure out the right tools and draw any marks.
    callback?()

  addFrame: (imgSrc, callback) ->
    image = @frameGroup.addShape 'image'
    @frames.push image

    loadImage imgSrc, ({src, width, height}) =>
      image.attr
        'xlink:href': src
        width: width
        height: height
        x: width / -2
        y: height / -2

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
    'change input[name="hide-old-marks"]': ->
      hide = @oldMarksToggle.prop 'checked'
      for tool in @markingSurface.tools
        tool.deselect()
        tool.attr 'data-hidden', if hide then true else null

    'click button[name="play-frames"]': ->
      @playFrames()
      @pauseButton.focus()

    'click button[name="pause-frames"]': ->
      @pauseFrames()
      @playButton.focus()

    'click button[name="toggle-frame"]': (e) ->
      @goTo e.currentTarget.value

module.exports = SubjectViewer
