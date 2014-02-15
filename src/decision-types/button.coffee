Controller = require 'zooniverse/controllers/base-controller'

class ButtonDecisionType extends Controller
  className: 'decision-tree-step button-step'
  template: require './templates/button'

  key: ''
  question: ''
  choices: null
  color: ''
  next: null

  constructor: (options = {}) ->
    # TODO: Fix this in zooniverse/controllers/base-controller
    @[key] = value for key, value of options
    super

  events:
    'click button': (e) ->
      choice = @choices[e.currentTarget.value]
      value = choice.value
      @el.trigger 'change-annotation', [@key, value]
      @el.trigger 'request-step', [if 'next' of choice then choice.next else @next]

module.exports = ButtonDecisionType
