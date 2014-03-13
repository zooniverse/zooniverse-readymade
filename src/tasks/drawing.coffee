RadioTask = require './radio'

class DrawingTask extends RadioTask
  @type: 'drawing'

  tools:
    point: require '../drawing-tools/point'
    ellipse: require 'marking-surface/lib/tools/ellipse'
    rect: require 'marking-surface/lib/tools/rectangle'
    text: require 'marking-surface/lib/tools/transcription'

  SELECT_TOOL: 'decision-tree:select-drawing-tool'

  enter: ->
    super
    @el.addEventListener 'change', this, false

    if @choices.length is 1
      @reset @choices[0].value
      @selectTool @choices[0].value, @choices[0]

  exit: ->
    super
    @el.removeEventListener 'change', this, false
    @dispatchEvent @CHANGE_TOOL, null

  handleEvent: (e) ->
    if e.type is 'change' and e.target.hasAttribute 'data-choice-index'
      choice = @getChoice()
      @selectTool choice.value, choice
    else
      super

  selectTool: (tool, choice) ->
    tool = @tools[tool] if typeof tool is 'string'
    @dispatchEvent @SELECT_TOOL, {tool, choice}

module.exports = DrawingTask
