RadioTask = require './radio'

class DrawingTask extends RadioTask
  @type: 'drawing'
  
  value = []

  tools:
    point: require '../drawing-tools/point'
    ellipse: require 'marking-surface/lib/tools/ellipse'
    rect: require 'marking-surface/lib/tools/rectangle'
    text: require 'marking-surface/lib/tools/transcription'

  SELECT_TOOL: 'decision-tree:select-drawing-tool'

  enter: ->
    super
    @el.addEventListener 'change', this, false

    if @choices.length is 1
      @check @choices[0]
    else
      for choice in @choices
        @check choice if choice.checked

  exit: ->
    super
    @el.removeEventListener 'change', this, false
    @dispatchEvent @CHANGE_TOOL, null

  handleEvent: (e) ->
    if e.type is 'change' and e.target.hasAttribute 'data-choice-index'
      choice = @getChoice()
      @selectTool choice.type, choice
    else
      super

  selectTool: (tool, choice) ->
    tool = @tools[tool] if typeof tool is 'string'
    @dispatchEvent @SELECT_TOOL, {tool, choice}
  
  check: (choice) ->
    @el.querySelector('input:checked')?.checked = false

    @el.querySelector("[value=#{choice.value}]").checked = true if choice?
    
    @selectTool choice.type, choice
  
  reset: (value = []) ->
    @value = value
  
  getValue: ->
    @value
    
  addMark: (mark) ->
    @value.push mark

module.exports = DrawingTask
