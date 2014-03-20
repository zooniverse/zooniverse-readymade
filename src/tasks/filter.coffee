RadioTask = require './radio'

class FilterTask extends RadioTask
  @type: 'filter'

  filtersEl: null

  filtersTemplate: -> "
    <div class='readymade-classification-filters'>
      #{(@filterTemplate filter, i for filter, i in @filters).join '\n'}
    </div>
  "

  filterTemplate: (filter, i) -> "
    <div class='readymade-classification-filter'>
      <span class=''>#{filter.label}</span>
      <select data-filter='#{filter.key}' data-filter-index='#{i}'>
        <option selected='selected'>&mdash;</option>
        #{"<option value='#{value.value}' data-filter-value-index='#{v}'>#{value.label}</option>" for value, v in filter.values}
      </select>
    </div>
  "

  renderTemplate: ->
    super
    questionEl = @el.querySelector '.decision-tree-question'
    questionEl.insertAdjacentHTML 'afterEnd', @filtersTemplate()
    @filtersEl = @el.querySelector '.readymade-classification-filters'

  enter: ->
    super
    @filtersEl.addEventListener 'change', this

  exit: ->
    @filtersEl.removeEventListener 'change', this
    super

  handleEvent: (e) ->
    if e.type is 'change' and e.currentTarget is @filtersEl
      @handleFilterChange e
    else
      super

  handleFilterChange: ->
    filterSettings = {}

    selects = @filtersEl.querySelectorAll '[data-filter-index]'
    choiceEls = @el.querySelectorAll '[data-choice-index]'

    for filter, i in @filters
      if selects[i].selectedIndex > 0
        filterSettings[filter.key] = filter.values[selects[i].selectedIndex - 1].value

    for choice, i in choiceEls
      choice.removeAttribute 'data-filtered'
      for key, value of filterSettings
        unless value in @choices[i].traits[key]
          choice.setAttribute 'data-filtered', true

    console.log 'filter changed', JSON.stringify filterSettings

module.exports = FilterTask
