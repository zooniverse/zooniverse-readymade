Controller = require 'zooniverse/controllers/base-controller'

class DecisionTree extends Controller
  className: 'decision-tree'
  template: require './templates/decision-tree'
  defaultNextLabel: 'Continue'
  defaultFinishLabel: 'Done'

  constructor: (@steps) ->
    super null

    @stepElements = @el.find '[data-step-id]'

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

  getStepAndChoice: (e) ->
    stepId = e.currentTarget.name
    choiceIndex = parseFloat e.currentTarget.value

    step = @steps[stepId]
    choice = step.choices[choiceIndex]

    [step, choice]

  events:
    'click button[data-shape]': (e) ->
      [step, choice] = @getStepAndChoice e
      @trigger 'select-tool', [choice.type, choice]

    'change input[type="radio"], input[type="checkbox"]': (e) ->
      stepId = e.currentTarget.name
      [step, choice] = @getStepAndChoice e

      checkedOptions = @el.find "input[name='#{stepId}']:visible:checked"
      checkedIndices = (input.value for input in checkedOptions)
      value = (step.choices[index].value for index in checkedIndices)
      if choice.type is 'radio'
        value = value[0]

      @trigger 'answer', [stepId, value]

    'click button.decision-tree-answer': (e) ->
      stepId = e.currentTarget.name
      [step, choice] = @getStepAndChoice e

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
