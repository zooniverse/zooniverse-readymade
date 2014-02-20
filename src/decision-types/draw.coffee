Controller = require 'zooniverse/controllers/base-controller'

TOOLS =
  point: require 'marking-surface/lib/tools/point'
  circle: null
  ellipse: require 'marking-surface/lib/tools/ellipse'
  rect: require 'marking-surface/lib/tools/rectangle'
  text: require 'marking-surface/lib/tools/transcription'
  polygon: null

class DrawDecisionType extends Controller
  className: 'decision-tree-step draw-step'
  template: require './templates/draw'

  question: ''
  choices: null
  next: null

  elements:
    'input[type="radio"]': 'radioInputs'
    'button[name="confirm-and-continue"]': 'confirmButton'
    '.label-for-next': 'nextLabel'
    '.label-for-done': 'doneLabel'

  constructor: (options = {}) ->
    # TODO: Fix this in zooniverse/controllers/base-controller
    @[key] = value for key, value of options
    super

  events:
    'reset-step': ->
      @radioInputs.prop 'checked', false
      @nextLabel.toggle true
      @doneLabel.toggle false

    'change input': (e) ->
      choice = @choices[e.currentTarget.value]

      shape = choice.shape
      if typeof shape is 'string'
        shape = TOOLS[shape]

      @el.trigger 'choose-tool', [shape, choice]

      @nextLabel.toggle @next?
      @doneLabel.toggle !@next?

    'click button[name="confirm-and-continue"]': ->
      @el.trigger 'request-step', @next

module.exports = DrawDecisionType
