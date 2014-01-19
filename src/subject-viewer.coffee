Controller = require 'zooniverse/controllers/base-controller'
MarkingSurface = require 'marking-surface'

loadImage = (src, callback) ->
  img = new Image
  img.onload = -> callback? img
  img.src = src

class SubjectViewer extends Controller
  className: 'subject-viewer'
  template: require './templates/subject-viewer'

  elements:
    '.marking-surface-container': 'markingSurfaceContainer'
    'button[name="play-frames"]': 'playButton'
    'button[name="pause-frames"]': 'pauseButton'
    '.frame-toggles ul': 'togglesList'

  constructor: ->
    super

    @markingSurface = new MarkingSurface
    @markingSurfaceContainer.append @markingSurface.el

    @frameGroup = @markingSurface.addShape 'g.frames'
    @frames = []

  loadSubject: (@subject) ->
    @pauseFrames()

    @markingSurface.reset()
    @frames.pop().remove() until @frames.length is 0
    @togglesList.empty()

    widths = []
    heights = []
    for imgSrc, i in @subject.location.standard then do (i) =>
      @addFrame imgSrc, (image) =>
        widths.push image.attr 'width'
        heights.push image.attr 'height'
        maxWidth = Math.max widths...
        maxHeight = Math.max heights...
        @markingSurface.el.style.width = "#{maxWidth}px"
        @markingSurface.el.style.height = "#{maxHeight}px"
        @frameGroup.attr transform: "translate(#{maxWidth / 2}, #{maxHeight / 2})"

        @addToggle i

    @playButton.prop 'disabled', @subject.location.standard.length is 1

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

  goTo: (index) ->
    @frames[index].toFront()

    buttons = @togglesList.find 'button'
    buttons.attr 'data-selected', null
    buttons.eq(index).attr 'data-selected', true

  playFrames: ->
    @playButton.prop 'disabled', true
    @pauseButton.prop 'disabled', false
    # TODO

  pauseFrames: ->
    @playButton.prop 'disabled', false
    @pauseButton.prop 'disabled', true
    # TODO

  events:
    'click button[name="play-frames"]': ->
      @playFrames()

    'click button[name="pause-frames"]': ->
      @pauseFrames()

    'click button[name="toggle-frame"]': (e) ->
      @goTo e.currentTarget.value

module.exports = SubjectViewer
