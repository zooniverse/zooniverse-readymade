BaseDecisionType = require './base'

class RadioDecisionType extends BaseDecisionType
  choiceClassName: 'radio-step'
  choiceTemplate: require './templates/radio-choice'

  reset: ->
    super
    @el.find(':checked').prop 'checked', false

  getNext: ->
    choice = @choices[@el.find(':checked').attr 'data-index']
    if choice? and 'next' of choice then choice.next else @next

  events: @extend @::events,
    'change input[name="choose-radio"]': (e) ->
      choice = @choices[e.currentTarget.getAttribute 'data-index']
      @el.trigger 'change-annotation', [@key, choice.value]

module.exports = RadioDecisionType
