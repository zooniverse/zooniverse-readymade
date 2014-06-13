$ = window.jQuery

class MiniTutorial
  steps = []

  closeLabel: '&times;'
  previousLabel: 'Previous'
  nextLabel: 'Next'
  finishLabel: 'Finished'

  index: 0

  template: -> "
    <button type='button' name='readymade-mini-tutorial-close'>#{@closeLabel}</button>

    <div class='readymade-mini-tutorial-images'>
      #{("
        <img src='#{step.image}' class='readymade-mini-tutorial-image' />
      " for step in @steps).join '\n'}
    </div>

    <div class='readymade-mini-tutorial-contents'>
      #{("
        <div class='readymade-mini-tutorial-content'>#{step.content}</div>
      " for step in @steps).join '\n'}
    </div>

    <div class='readymade-mini-tutorial-actions'>
      <button type='button' name='readymade-mini-tutorial-previous'>
        <span class='readymade-mini-tutorial-button-label'>#{@previousLabel}</span>
      </button>

      <button type='button' name='readymade-mini-tutorial-next'>
        <span class='readymade-mini-tutorial-button-label'>#{@nextLabel}</span>
      </button>

      <button type='button' name='readymade-mini-tutorial-finish'>
        <span class='readymade-mini-tutorial-button-label'>#{@finishLabel}</span>
      </button>
    </div>

    <div class='readymade-mini-tutorial-steppers'>
      #{("
        <button type='button' name='readymade-mini-tutorial-stepper' value='#{i}'>
          <span class='readymade-mini-tutorial-button-label'>#{i + 1}</span>
        </button>
      " for step, i in @steps).join '\n'}
    </div>
  "

  constructor: (options) ->
    for key, value of options
      @[key] = value

    @el ?= document.createElement 'div'
    @el.classList.add 'readymade-mini-tutorial-underlay'

    @close()

    @dialog ?= document.createElement 'div'
    @dialog.classList.add 'readymade-mini-tutorial-dialog'

    @dialog.insertAdjacentHTML 'afterBegin', @template()

    @images = @dialog.querySelectorAll '.readymade-mini-tutorial-image'
    @contents = @dialog.querySelectorAll '.readymade-mini-tutorial-content'
    @previousButton = @dialog.querySelector '[name="readymade-mini-tutorial-previous"]'
    @nextButton = @dialog.querySelector '[name="readymade-mini-tutorial-next"]'
    @finishButton = @dialog.querySelector '[name="readymade-mini-tutorial-finish"]'
    @steppers = @dialog.querySelectorAll '[name="readymade-mini-tutorial-stepper"]'

    $(@el).on 'click', '[name="readymade-mini-tutorial-close"]', @close.bind this

    $(@el).on 'click', '[name="readymade-mini-tutorial-previous"]', @previous.bind this
    $(@el).on 'click', '[name="readymade-mini-tutorial-next"]', @next.bind this
    $(@el).on 'click', '[name="readymade-mini-tutorial-finish"]', @close.bind this

    $(@el).on 'click', '[name="readymade-mini-tutorial-stepper"]', (e) =>
      @goTo parseFloat e.target.value

    @el.appendChild @dialog

    @goTo @index

  goTo: (@index) ->
    @index %%= @steps.length

    for elements in [@images, @contents, @steppers]
      for element, i in elements
        if i is index
          element.setAttribute 'data-readymade-active', true
        else
          element.removeAttribute 'data-readymade-active'

    @previousButton.disabled = @index is 0

    lastStep = @steps.length - 1
    @nextButton.disabled = @index is lastStep
    @finishButton.disabled = @index isnt lastStep

    return

  previous: ->
    @goTo @index - 1
    return

  next: ->
    @goTo @index + 1
    return
    @dialog.querySelector('button').focus()

  open: ->
    @el.setAttribute 'data-transitioning', true
    setTimeout =>
      @el.setAttribute 'data-open', true
      @el.removeAttribute 'data-transitioning'
    return

  close: ->
    @el.setAttribute 'data-transitioning', true
    @el.removeAttribute 'data-open'
    setTimeout @el.removeAttribute.bind(@el, 'data-transitioning'), 250
    return

module.exports = MiniTutorial
