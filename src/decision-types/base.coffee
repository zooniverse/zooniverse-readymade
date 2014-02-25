Controller = require 'zooniverse/controllers/base-controller'
$ = window.jQuery

class BaseDecisionType extends Controller
  @extend = ->
    $.extend {}, arguments...

  className: 'decision-tree-step'
  template: require './templates/base'

  choiceClassName: 'base-choice'
  choiceTemplate: null

  question: ''
  choices: null
  next: null

  elements:
    'button[name="confirm-and-continue"]': 'confirmButton'

  constructor: (options = {}) ->
    # TODO: Fix this in zooniverse/controllers/base-controller
    @[key] = value for key, value of options
    super

    @el.attr 'data-step-id', @key
    @reset()

  reset: ->
    @updateConfirmButton()

  enter: ->
    @el.addClass 'selected'
    @el.css 'display', ''

  exit: ->
    @el.removeClass 'selected'
    @el.css 'display', 'none'

  getNext: ->
    @next

  updateConfirmButton: ->
    @el.toggleClass 'is-last-step', not @getNext()?

  confirm: ->
    @el.trigger 'request-step', @getNext()

  events:
    'click button:not([type])': (e) ->
      e.preventDefault()

    'click button[name="confirm-and-continue"]': ->
      @confirm()

module.exports = BaseDecisionType
