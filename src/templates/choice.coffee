# This is not a proper eco template at the moment because it takes arguments.

typeMap =
  'drawing': 'radio'
  'filter': 'radio'

module.exports = (choice, i) -> "
  <label class='readymade-choice-input-wrapper'>
    <input type='#{typeMap[@constructor?.type] ? typeMap[@type] ? @constructor?.type ? @type}' name='#{@key}' value='#{choice.value}' data-choice-index='#{i}' />

    <div class='readymade-choice-clickable readymade-choice-#{@constructor.type ? @type}'>
      <div class='readymade-choice-tickbox'>
        <div class='readymade-choice-tick'></div>
      </div>

      #{if choice.image? then "<div class='readymade-choice-image'><img src='#{choice.image}' /></div>" else ''}

      <div class='readymade-choice-label'>#{choice.label ? choice.value ? i}</div>

      #{if choice.color? then "<div class='readymade-choice-color' style='color: #{choice.color};'></div>" else ''}
    </div>
  </label>
"
