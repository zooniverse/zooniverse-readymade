Controller = require 'zooniverse/controllers/base-controller'

class DecisionTree extends Controller
  goTo: (questionId) ->
    questionEl = $('<div></div>')

module.exports = DecisionTree
