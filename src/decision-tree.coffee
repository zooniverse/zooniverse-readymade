Controller = require 'zooniverse/controllers/base-controller'

class DecisionTree extends Controller
  className: 'decision-tree'
  template: require './templates/decision-tree'
  defaultNextLabel: 'Continue'
  defaultFinishLabel: 'Done'

  elements:
    '.decision-tree-step': 'stepElements'

  constructor: (@steps) ->
    super null

    stepKeys = Object.keys @steps
    if stepKeys.length is 1
      @firstStep = stepKeys[0]
    else
      @firstStep = @steps.first
      unless @firstStep?
        throw new Error 'There is no "first" classification step defined.'

  goTo: (stepId) ->
    stepElement = @stepElements.filter "[data-step-id='#{stepId}']"
    # console.log "Going to #{stepId}"
    @stepElements.removeClass 'selected'
    stepElement.addClass 'selected'
    @trigger 'go-to', [stepId]

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

      console.log choiceIndex

      if choice? and 'value' of choice
        @trigger 'answer', [stepId, choice.value]

      if choice? and 'next' of choice
        next = choice.next
      else
        next = step.next

      if typeof next is 'function'
        next = next.call this, e

      if next?
        @goTo next
      else
        @trigger 'finished-all-steps'

module.exports = DecisionTree
