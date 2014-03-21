RadioTask = require './radio'
Dropdown = require 'zooniverse/controllers/dropdown'
choiceTemplate = require '../templates/choice'

class FilterTask extends RadioTask
  @type: 'filter'

  filters: null

  currentFilters: null

  buttons: null
  menus: null
  clearButtons: null
  dropdowns: null

  filtersTemplate: -> "
    <div class='readymade-classification-filters'>
      #{("
        <div class='readymade-classification-filter'>
          <button name='#{filter.key}' class='readymade-filter-button'>#{filter.label}</button>

          <div class='readymade-filter-menu'>
            <form>
              #{(@valueTemplate filter, value, v for value, v in filter.values).join '\n'}
              #{@valueTemplate {key: filter.key, type: 'button'}, {label: '&times;', value: ''}, 0}
            </form>
          </div>
        </div>
      " for filter, i in @filters).join '\n'}
    </div>
  "

  valueTemplate: (filter, value, i) ->
    filter = Object.create filter
    filter.type ?= 'radio'
    choiceTemplate.call filter, value, i

  constructor: ->
    super
    @currentFilters ?= {}
    @reflectFilter()

  renderTemplate: ->
    super
    questionEl = @el.querySelector '.decision-tree-question'
    questionEl.insertAdjacentHTML 'afterEnd', @filtersTemplate()

    filtersEl = @el.querySelector '.readymade-classification-filters'

    @buttons = Array::slice.call filtersEl.querySelectorAll '.readymade-filter-button'
    @menus = Array::slice.call filtersEl.querySelectorAll '.readymade-filter-menu'
    @clearButtons = for menu in @menus
      menu.querySelector 'input[type="button"][value=""]'

    @dropdowns = for i in [0...@buttons.length]
      new Dropdown
        button: @buttons[i]
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
      @handleFilterChange @menus.indexOf e.currentTarget
      Dropdown.closeAll()
    else if e.type is 'click' and e.currentTarget in @clearButtons
      @clearFilter @clearButtons.indexOf e.currentTarget
    else
      super

  handleFilterChange: (index) ->
    checked = @menus[index].querySelector ':checked'
    if checked
      valueIndex = checked.getAttribute 'data-choice-index'
      @currentFilters[@filters[index].key] = @filters[index].values[valueIndex].value

    @reflectFilter @currentFilters

  clearFilter: (index) ->
    @menus[index].querySelector(':checked')?.checked = false
    delete @currentFilters[@filters[index].key]
    @reflectFilter @currentFilters

  reflectFilter: (filterSettings) ->
    choiceEls = @el.querySelectorAll '[data-choice-index]'
    for choice, i in choiceEls
      choice.removeAttribute 'data-filtered'
      for key, value of filterSettings
        unless value in @choices[i].traits[key]
          choice.setAttribute 'data-filtered', true

module.exports = FilterTask
