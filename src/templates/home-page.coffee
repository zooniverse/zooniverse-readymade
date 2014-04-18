dash = require '../lib/dash'

module.exports = (context) ->
  template = ->
    workflows = @workflows ? [label: 'Classify']

    "
      <div class='readymade-home-page'>
        #{if @summary then "
          <div class='readymade-project-summary'>
            #{@summary}
          </div>
        " else ''}

        #{if @description then "
          <div class='readymade-project-description'>
            #{@description}
          </div>
        " else ''}

        <div class='readymade-footer'>
          #{(for {label} in workflows then "
            <a href='#/#{dash label}' class='readymade-call-to-action'>
              #{label}
            </a>
          ").join '\n'}
        </div>
      </div>
    "
  template.call context
