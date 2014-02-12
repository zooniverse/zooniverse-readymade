Controller = require 'zooniverse/controllers/base-controller'

class DecisionTree extends Controller
  steps: null
  firstStep: ''

  className: 'decision-tree'
  template: require './templates/decision-tree'
  defaultNextLabel: 'Continue'
  defaultFinishLabel: 'Done'

  elements:
    '.decision-tree-step': 'stepElements'

  constructor: ->
    @steps = {}

    super

    unless @firstStep
      stepKeys = Object.keys @steps
      if stepKeys.length is 1
        @firstStep = stepKeys[0]

    unless @firstStep of @steps
      throw new Error 'There is no "first" classification step defined.'

  goTo: (stepId) ->
    if typeof stepId is 'function'
      @goTo stepId.call this
    else if stepId of @steps
      stepElement = @stepElements.filter "[data-step-id='#{stepId}']"
      @stepElements.removeClass 'selected'
      stepElement.addClass 'selected'
      @trigger 'go-to', [stepId]
    else
      @trigger 'finished-all-steps'

  reset: ->
    @el.find('input:checked').prop 'checked', false
    @goTo @firstStep

  events:
    'change .decision-tree-shape': (e) ->
      stepId = e.target.name
      choiceIndex = parseFloat e.target.value

      step = @steps[stepId]
      choice = step.choices[choiceIndex]

      @trigger 'select-tool', [choice.type, choice]

    'change .decision-tree-radio, .decision-tree-checkbox': (e) ->
      stepId = e.target.name
      choiceIndex = parseFloat e.target.value

      step = @steps[stepId]
      choice = step.choices[choiceIndex]

      checkedOptions = @el.find "input[name='#{stepId}']:visible:checked"
      checkedIndices = (input.value for input in checkedOptions)
      value = (step.choices[index].value for index in checkedIndices)
      if choice.type is 'radio'
        value = value[0]

      @trigger 'answer', [stepId, value]

    'click .decision-tree-answer': (e) ->
      stepId = e.currentTarget.name
      choiceIndex = parseFloat e.currentTarget.value

      step = @steps[stepId]
      choice = step.choices[choiceIndex]

      if choice? and 'value' of choice
        @trigger 'answer', [stepId, choice.value]

      next = if choice? and 'next' of choice
        choice.next
      else
        step.next

      @goTo next

module.exports = DecisionTree
