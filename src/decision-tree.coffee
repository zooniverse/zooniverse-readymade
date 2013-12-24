Controller = require 'zooniverse/controllers/base-controller'

class DecisionTree extends Controller
  goTo: (questionId) ->
    questionNode = $('<div></div>')

module.exports = DecisionTree
