BaseDecisionType = require './base'

TOOLS =
  point: require 'marking-surface/lib/tools/point'
  circle: null
  ellipse: require 'marking-surface/lib/tools/ellipse'
  rect: require 'marking-surface/lib/tools/rectangle'
  text: require 'marking-surface/lib/tools/transcription'
  polygon: null

class DrawDecisionType extends BaseDecisionType
  choiceClassName: 'draw-step'
  choiceTemplate: require './templates/draw-choice'

  elements: @extend @::elements,
    'input[type="radio"]': 'radioInputs'

  exit: ->
    super
    @el.trigger 'choose-tool', [null, null]

  reset: ->
    super
    @el.find(':checked').prop 'checked', false

  events: @extend @::events,
    'change input[name="choose-tool"]': (e) ->
      choice = @choices[e.currentTarget.getAttribute 'data-index']
      shape = choice.shape
      shape = TOOLS[shape] if typeof shape is 'string'
      @el.trigger 'choose-tool', [shape, choice]

module.exports = DrawDecisionType
