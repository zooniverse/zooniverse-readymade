Controller = require 'zooniverse/controllers/base-controller'

class RadioDecisionType extends Controller
  className: 'decision-tree-step radio-step'
  template: require './templates/radio'

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
      @confirmButton.prop 'disabled', true
      @nextLabel.toggle true
      @doneLabel.toggle false

    'change input': (e) ->
      choice = @choices[e.currentTarget.value]
      value = choice.value
      @el.trigger 'change-annotation', [@key, value]

      @confirmButton.prop 'disabled', false

      next = if 'next' of choice then choice.next else @next
      @nextLabel.toggle next?
      @doneLabel.toggle !next?

    'click button[name="confirm-and-continue"]': ->
      selectedIndex = @el.find(':checked').val()
      choice = @choices[selectedIndex]
      @el.trigger 'request-step', [if 'next' of choice then choice.next else @next]

module.exports = RadioDecisionType
