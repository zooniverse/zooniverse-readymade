Controller = require 'zooniverse/controllers/base-controller'
MarkingSurface = require 'marking-surface'

class SubjectViewer extends Controller
  className: ''
  template: require './templates/subject-viewer'

  constructor: ->
    super

    @markingSurface = new MarkingSurface
    @el.append @markingSurface.el

module.exports = SubjectViewer
