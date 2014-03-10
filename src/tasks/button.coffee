BaseButtonTask = require 'zooniverse-decision-tree/lib/button-task'

class ButtonTask extends BaseButtonTask
  choiceTemplate: require '../templates/choice'

module.exports = ButtonTask
