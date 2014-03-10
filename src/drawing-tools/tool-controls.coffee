{ToolControls: BaseToolControls} = require 'marking-surface'

class ToolControls extends BaseToolControls
  template: require '../templates/tool-controls'

  constructor: ->
    super

    setTimeout =>
      @el.innerHTML = @template @tool.details

    @addEvent 'click', 'button[name="readymade-destroy-drawing"]', [@tool.mark, 'destroy']

  render: ->
    super

module.exports = ToolControls
