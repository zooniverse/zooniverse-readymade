Controller = require 'zooniverse/controllers/base-controller'

class DecisionTree extends Controller
  steps: null
  firstStep: ''

  className: 'readymade-decision-tree'
  defaultNextLabel: 'Continue'
  defaultFinishLabel: 'Done'

  stepTypes:
    radio: require './decision-types/radio'
    button: require './decision-types/button'
    draw: require './decision-types/draw'

  constructor: ->
    @steps = {}
    super

    unless @firstStep
      stepKeys = Object.keys @steps
      if stepKeys.length is 1
        @firstStep = stepKeys[0]

    unless @firstStep of @steps
      throw new Error 'There is no "first" classification step defined.'

    for stepId, step of @steps when typeof step isnt 'string'
      step = Object.create step
      step.key ?= stepId
      instance = new @stepTypes[step.type] step
      instance.el.attr 'data-step-id', stepId
      @el.append instance.el

    @stepElements = @el.children()

  goTo: (stepId) ->
    if typeof stepId is 'function'
      @goTo stepId.call this
    else if stepId of @steps
      stepElement = @stepElements.filter "[data-step-id='#{stepId}']"
      @stepElements.removeClass 'selected'
      stepElement.addClass 'selected'
      @el.trigger 'change-step', [stepId]
    else
      @el.trigger 'finished-all-steps'

  reset: ->
    @goTo @firstStep
    @stepElements.trigger 'reset-step'

  events:
    'request-step': (e, stepId) ->
      @goTo stepId

module.exports = DecisionTree
