Controller = require 'zooniverse/controllers/base-controller'

class DecisionTree extends Controller
  className: 'decision-tree'
  template: require './templates/decision-tree'

  constructor: (@questions) ->
    super null

    @first = @questions.first
    unless @first?
      throw new Error 'There is no "first" classification question defined.'

  goTo: (questionId) ->
    questionEl = $('<div></div>')

module.exports = DecisionTree
