BaseRadioTask = require 'zooniverse-decision-tree/lib/radio-task'

class RadioTask extends BaseRadioTask
  choiceTemplate: require '../templates/choice'

module.exports = RadioTask
