BaseCheckboxTask = require 'zooniverse-decision-tree/lib/checkbox-task'

class CheckboxTask extends BaseCheckboxTask
  choiceTemplate: require '../templates/decision-tree-task-choice'

module.exports = CheckboxTask
