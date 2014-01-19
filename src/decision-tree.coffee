Controller = require 'zooniverse/controllers/base-controller'

class DecisionTree extends Controller
  className: 'decision-tree'
  template: require './templates/decision-tree'
  defaultContinueLabel: 'Continue'

  constructor: (@steps) ->
    super null

    @stepElements = @el.find '[data-step-id]'

    stepKeys = Object.keys @steps
    if stepKeys.length is 1
      first = stepKeys[0]
    else
      first = @steps.first
      unless first?
        throw new Error 'There is no "first" classification step defined.'

    @goTo first

  goTo: (stepId) ->
    stepElement = @stepElements.filter "[data-step-id='#{stepId}']"
    console.log "Going to #{stepId}", stepElement
    @stepElements.removeClass 'selected'
    stepElement.addClass 'selected'

  events:
    'click button[data-shape]': (e) ->
      shape = e.currentTarget.getAttribute 'data-shape'
      console.log "Changing drawing tool to #{shape} for #{e.currentTarget.value} in #{e.currentTarget.name}"
      @trigger 'select-tool', [shape]

    'change input[type="radio"], input[type="checkbox"]': (e) ->
      {name, type} = e.currentTarget
      checkedOptions = @el.find "input[name='#{name}']:checked"
      value = (input.value for input in checkedOptions)
      value = value[0] if type is 'radio'
      console.log "Set #{name} to #{value}"
      @trigger 'answer', [e.currentTarget.name, value]

    'click button.decision-tree-answer': (e) ->
      {name, value} = e.currentTarget
      unless value is 'NO_VALUE'
        console.log "Set #{name} to #{value}"
        @trigger 'answer', [e.currentTarget.name, e.currentTarget.value]

      next = @steps[name].next
      console.log "Next is #{next}"

      if next?
        @goTo next
      else
        @trigger 'finished'

module.exports = DecisionTree
