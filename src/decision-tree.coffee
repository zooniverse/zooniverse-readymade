Controller = require 'zooniverse/controllers/base-controller'

class DecisionTree extends Controller
  stepSpecs: null
  firstStep: ''

  className: 'readymade-decision-tree'
  defaultNextLabel: 'Continue'
  defaultFinishLabel: 'Done'

  stepTypes:
    _base: require './decision-types/base' # Just include this here for testing.
    radio: require './decision-types/radio'
    button: require './decision-types/button'
    draw: require './decision-types/draw'

  currentDecision: null

  constructor: ->
    @stepSpecs = {}
    super

    unless @firstStep
      stepKeys = Object.keys @stepSpecs
      if stepKeys.length is 1
        @firstStep = stepKeys[0]

    unless @firstStep of @stepSpecs
      throw new Error 'There is no "first" classification step defined.'

    @decisions = {}
    for stepId, step of @stepSpecs when typeof step isnt 'string'
      step = Object.create step
      step.key ?= stepId
      step.type = @stepTypes[step.type] if typeof step.type is 'string'

      @decisions[stepId] = new step.type step
      @el.append @decisions[stepId].el

    @stepElements = @el.children()

  goTo: (stepId) ->
    if typeof stepId is 'function'
      @goTo stepId.call this
    else if stepId of @decisions
      decision = @decisions[stepId]
      unless decision is @currentDecision
        @currentDecision?.exit()
        @currentDecision = null

        decision.enter()
        @el.trigger 'change-step', [stepId]
        @currentDecision = decision
    else
      @el.trigger 'finished-all-steps'

  reset: ->
    @goTo @firstStep
    for stepId, decision of @decisions
      decision.reset()

  events:
    'request-step': (e, stepId) ->
      @goTo stepId

module.exports = DecisionTree
