{ToolControls: BaseToolControls} = require 'marking-surface'
{Task} = require 'zooniverse-decision-tree'

class ToolControls extends BaseToolControls
  template: require('../templates/tool-controls')()
  details: null

  taskTypes:
    radio: require '../tasks/radio'
    checkbox: require '../tasks/checkbox'

  constructor: ->
    @detailTasks = {}

    super
    @addEvent 'click', 'button[name="readymade-destroy-drawing"]', [@tool.mark, 'destroy']
    @addEvent 'change', @onChange

    setTimeout => # Ugh.
      if @details?
        for detail in @details
          @addDetail detail

  addDetail: (detail) ->
    form = @el.querySelector 'form'

    unless detail instanceof Task
      detail = new @taskTypes[detail.type] detail
    @detailTasks[detail.key] = detail
    detail.renderTemplate()
    detail.show()
    form.appendChild detail.el

  onChange: (e) ->
    for key, task of @detailTasks
      @tool.mark.set key, task.getValue()

  render: ->
    setTimeout => # Ugh.
      for key, task of @detailTasks
        task.reset @tool.mark[key]

module.exports = ToolControls
