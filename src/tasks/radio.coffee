BaseRadioTask = require 'zooniverse-decision-tree/lib/radio-task'

class RadioTask extends BaseRadioTask
  choiceTemplate: require '../templates/decision-tree-task-choice'

module.exports = RadioTask
