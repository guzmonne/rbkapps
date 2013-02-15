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
    'click #submit-create-item': 'createItem'

  initialize: ->
    @model = new App.Models.Item()
    @brands   = App.items.pluckDistinct('brand')
    @seasons  = App.items.pluckDistinct('season')
    @entries  = App.items.pluckDistinct('entry')
    @formHelper = new App.Mixins.Form()

  render: ->
    $(@el).html(@template(brands: @brands, seasons: @seasons, entries: @entries))
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
    e.preventDefault() unless e == undefined
    @formHelper.cleanForm('#create-item')
    @formHelper.removeValidations()

  createItem: (e) ->
    e.preventDefault()
    if $('#brand').val() == "Seleccione una Marca" then return@formHelper.showInForm('brand', 'no puede quedar en blanco')
    if $('#season').val() == "Seleccione una Temporada" then return @formHelper.showInForm('season', 'no puede quedar en blanco')
    if $('#entry').val() == "Seleccione un Rubro" then return @formHelper.showInForm('entry', 'no puede quedar en blanco')
    attributes =
      item:
        code  : $('#code').val()
        brand : $('#brand').val()
        season: $('#season').val()
        entry : $('#entry').val()
    @model.save attributes, {success: @handleSuccess, error: @handleError}
    this

  handleSuccess: (data, status, response) =>
    @cleanForm()
    @formHelper.displayFlash('success', 'El Artículo se ha creado con exito')
    App.items.add @model
    console.log @model
    this

  handleError: (model, data, options) =>
    @formHelper.displayFlash("error","Por favor verifique sus datos.")
    if data.status == 422
      errors = $.parseJSON(data.responseText).errors
      for attribute, messages of errors
        @formHelper.showInForm(attribute, message) for message in messages