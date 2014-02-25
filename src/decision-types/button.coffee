BaseDecisionType = require './base'

class ButtonDecisionType extends BaseDecisionType
  choiceClassName: 'button-step'
  choiceTemplate: require './templates/button-choice'

  enter: ->
    super
    @confirmButton.css 'display', 'none'

  exit: ->
    super
    @confirmButton.css 'display', ''

  events: @extend @::events,
    'click button[name="make-choice"]': (e) ->
      choice = @choices[e.currentTarget.getAttribute 'data-index']
      @el.trigger 'change-annotation', [@key, choice.value]
      @confirm choice.next ? @next

module.exports = ButtonDecisionType
