RadioTask = require 'zooniverse-decision-tree/lib/radio-task'
DecisionTree = require 'zooniverse-decision-tree'

class DrawingTask extends RadioTask
  tools:
    point: require 'marking-surface/lib/tools/point'
    ellipse: require 'marking-surface/lib/tools/ellipse'
    rect: require 'marking-surface/lib/tools/rectangle'
    text: require 'marking-surface/lib/tools/transcription'

  type: 'drawing'

  SELECT_TOOL: 'decision-tree:select-drawing-tool'

  enter: ->
    super
    @el.addEventListener 'change', this, false

  exit: ->
    super
    @dispatchEvent @CHANGE_TOOL, null
    @el.removeEventListener 'change', this, false

  handleEvent: (e) ->
    if e.type is 'change'
      tool = @getChoice().tool || @tools.point
      tool = @tools[tool] if typeof tool is 'string'
      @dispatchEvent @SELECT_TOOL, {tool, @choice}
    else
      super

DecisionTree.registerTask DrawingTask
module.exports = DrawingTask
