BaseCheckboxTask = require 'zooniverse-decision-tree/lib/checkbox-task'

class CheckboxTask extends BaseCheckboxTask
  choiceTemplate: require '../templates/choice'

module.exports = CheckboxTask
