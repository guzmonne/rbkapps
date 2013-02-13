class App.Views.ItemCreate extends Backbone.View
  template: JST['items/create']
  name: 'ItemCreate'
  className: 'span12'

  events:
    'click #add-new-brand': 'addNewBrand'
    'click #submit-new-brand': 'addNewBrand'
    'click #add-new-season': 'addNewSeason'
    'click #submit-new-season': 'addNewSeason'
    'click #add-new-entry': 'addNewEntry'
    'click #submit-new-entry': 'addNewEntry'
    'click #clear-form': 'cleanForm'

  initialize: ->
    @model = new App.Models.Item()
    @brands = App.items.pluckDistinct('brand')
    @formHelper = new App.Mixins.Form()

  render: ->
    $(@el).html(@template(brands: @brands))
    this

  addNewBrand: (e) ->
    e.preventDefault()
    @formHelper.modalToSelect("#add-new-brand-modal", "#new-brand", "#brand")
    this

  addNewSeason: (e) ->
    e.preventDefault()
    @formHelper.modalToSelect("#add-new-season-modal", "#new-season", "#season")
    this

  addNewEntry: (e) ->
    e.preventDefault()
    @formHelper.modalToSelect("#add-new-entry-modal", "#new-entry", "#entry")
    this

  cleanForm: (e) ->
    e.preventDefault()
    @formHelper.cleanForm('#create-item')
    @formHelper.removeValidations()