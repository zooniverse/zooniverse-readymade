RadioTask = require 'zooniverse-decision-tree/lib/radio-task'
DecisionTree = require 'zooniverse-decision-tree'

class DrawingTask extends RadioTask
  type: 'drawing'

  tools:
    point: require 'marking-surface/lib/tools/point'
    ellipse: require 'marking-surface/lib/tools/ellipse'
    rect: require 'marking-surface/lib/tools/rectangle'
    text: require 'marking-surface/lib/tools/transcription'

  SELECT_TOOL: 'decision-tree:select-drawing-tool'

  enter: ->
    super
    @el.addEventListener 'change', this, false

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

DecisionTree.registerTask DrawingTask
module.exports = DrawingTask
