# This is not a proper eco template at the moment because it takes arguments.

typeMap =
  'drawing': 'radio'

module.exports = (choice, i) -> "
  <label class='decision-tree-input-wrapper'>
    <input type='#{typeMap[@constructor.type] ? @constructor.type}' name='#{@key}' value='#{choice.value}' data-choice-index='#{i}' />

    <div class='decision-tree-clickable decision-tree-#{@constructor.type}'>
      <div class='decision-tree-tickbox'>
        <div class='decision-tree-tick'></div>
      </div>

      #{if choice.image? then "<div class='decision-tree-image'><img src='#{choice.image}' /></div>" else ''}

      <div class='decision-tree-label'>#{choice.label ? choice.value ? i}</div>
    </div>
  </label>
"
