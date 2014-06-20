Controller = require 'zooniverse/controllers/base-controller'

class ClassificationSumary extends Controller
  DISMISS: 'zooniverse-readymade:classification-summary:dismiss'

  className: 'readymade-classification-summary'
  template: require './templates/classification-summary'

  elements:
    '.readymade-existing-comments': 'existingCommentsText'
    '.readymade-existing-comments-count': 'existingCommentsCount'
    '.readymade-talk-link': 'talkLink'
    '.readymade-twitter-link': 'twitterLink'
    '.readymade-facebook-link': 'facebookLink'

  loadSubject: (subject) ->
    currentProject = require 'zooniverse-readymade/current-project'

    @existingCommentsText.hide()
    @talkLink.attr 'href', subject.talkHref()
    @twitterLink.attr 'href', subject.twitterHref()
    @facebookLink.attr 'href', subject.facebookHref()

    currentProject.api.get "/projects/#{currentProject.api.project}/talk/subjects/#{subject.zooniverse_id}", (data) =>
      @existingCommentsCount.html data.discussion.comments_count
      unless data.discussion.comments_count is 0
        @existingCommentsText.show()


  events:
    'click button[name="readymade-dont-talk"]': ->
      @trigger @DISMISS

module.exports = ClassificationSumary
