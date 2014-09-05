$ = window.jQuery

class FieldGuide
  examples: null

  template: (examples) -> "
    <div class='readymade-field-guide-tabs'>
      #{("
        <button name='readymade-field-guide-tab' value='#{i}'>#{page.label}</button>
      " for page, i in examples).join '\n'}
    </div>

    <div class='readymade-field-guide-pages'>
      #{("
        <div class='readymade-field-guide-page'>
          <div class='readymade-field-guide-content'>#{page.content ? ''}</div>
          <div class='readymade-field-guide-examples'>
            #{("
              <div class='readymade-field-guide-example'>
                <img src='#{figure.image}' class='readymade-field-guide-image' />
                <div class='readymade-field-guide-caption'>#{figure.label}</div>
              </div>
            " for figure in page.figures).join '\n'}
          </div>
        </div>
      " for page in examples).join '\n'}
    </div>
  "

  constructor: (config) ->
    for key, value of config
      @[key] = value

    @examples ?= []

    @el ?= document.createElement 'div'
    @el = $(@el)
    @el.addClass 'readymade-field-guide'

    renderedHTML = @template @examples
    @el.append renderedHTML

    @el.on 'click', '[name="readymade-field-guide-tab"]', @handleTabClick

    @goTo 0

  handleTabClick: (e) =>
    @goTo parseFloat $(e.target).closest('[value]').val()

  goTo: (index) ->
    for tab, i in @el.find('[name="readymade-field-guide-tab"]')
      $(tab).toggleClass 'active', i is index
    for page, i in @el.find('.readymade-field-guide-page')
      $(page).toggle i is index

  destroy: ->
    @el.off 'click', '[readymade-field-guide-tab]', @handleTabClick

module.exports = FieldGuide
