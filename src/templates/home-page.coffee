dash = require '../lib/dash'

module.exports = (context) ->
  template = ->
    workflows = @workflows ? [label: 'Get started!', name: 'classify']

    "
      <div class='readymade-home-page'>
        <div class='readymade-home-page-content'>
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
            #{(for {name, label} in workflows then "
              <a href='#/#{name ? dash label}' class='readymade-call-to-action'>
                #{label}
              </a>
            ").join '\n'}
          </div>
        </div>
      </div>
    "
  template.call context
