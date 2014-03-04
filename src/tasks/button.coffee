BaseButtonTask = require 'zooniverse-decision-tree/lib/button-task'

class ButtonTask extends BaseButtonTask
  choiceTemplate: require '../templates/decision-tree-task-choice'

module.exports = ButtonTask
