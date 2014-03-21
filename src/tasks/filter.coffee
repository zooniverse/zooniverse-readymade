RadioTask = require './radio'
Dropdown = require 'zooniverse/controllers/dropdown'
choiceTemplate = require '../templates/choice'

class FilterTask extends RadioTask
  @type: 'filter'

  filters: null

  filtersEl: null

  filtersTemplate: -> "
    <div class='readymade-classification-filters'>
      #{(@filterTemplate filter, i for filter, i in @filters).join '\n'}
    </div>
  "

  valueTemplate: (filter, value, i) ->
    filter = Object.create filter
    filter.type ?= 'radio'
    choiceTemplate.call filter, value, i

  filterTemplate: (filter, i) -> "
    <div class='readymade-classification-filter'>
      <button name='#{filter.key}' class='readymade-filter-button'>#{filter.label}</button>

      <div class='readymade-filter-menu'>
        <form>
          #{(@valueTemplate filter, value, v for value, v in filter.values).join '\n'}
          #{@valueTemplate {key: filter.key, type: 'button'}, {label: '&times;', value: ''}, 0}
        </form>
      </div>
    </div>
  "

  renderTemplate: ->
    super
    questionEl = @el.querySelector '.decision-tree-question'
    questionEl.insertAdjacentHTML 'afterEnd', @filtersTemplate()
    filtersEl = @el.querySelector '.readymade-classification-filters'

    buttons = filtersEl.querySelectorAll '.readymade-filter-button'
    @menus = filtersEl.querySelectorAll '.readymade-filter-menu'
    @clearButtons = for menu in @menus
      menu.querySelector 'input[type="button"]'

    console.log @clearButtons
    for i in [0...buttons.length]
      new Dropdown
        button: buttons[i]
        menu: @menus[i]
        buttonPinning: [1, 1]
        menuPinning: [1, 0]

  enter: ->
    super
    for i in [0...@menus.length]
      @menus[i].addEventListener 'change', this
      @clearButtons[i].addEventListener 'click', this

  exit: ->
    for i in [0...@menus.length]
      @menus[i].removeEventListener 'change', this
      @clearButtons[i].removeEventListener 'click', this
    super

  handleEvent: (e) ->
    if e.type is 'change' and e.currentTarget in @menus
      @handleFilterChange e
    else if e.type is 'click' and e.currentTarget in @clearButtons
      @clearFilter @clearButtons.indexOf e.currentTarget
    else
      super

  clearFilter: (index) ->
    checked = @menus[index].querySelector ':checked'
    checked?.checked = false
    @handleFilterChange()

  handleFilterChange: ->
    filterSettings = {}

    for menu in @menus
      checked = menu.querySelector ':checked'
      if checked
        filterIndex = Array::indexOf.call @menus, menu
        valueIndex = checked.getAttribute 'data-choice-index'
        filterSettings[@filters[filterIndex].key] = @filters[filterIndex].values[valueIndex].value

    choiceEls = @el.querySelectorAll '[data-choice-index]'
    for choice, i in choiceEls
      choice.removeAttribute 'data-filtered'
      for key, value of filterSettings
        unless value in @choices[i].traits[key]
          choice.setAttribute 'data-filtered', true

module.exports = FilterTask
