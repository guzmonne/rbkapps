class App.Views.DeliveryCreate extends Backbone.View
  template: JST['deliveries/create']
  name: 'DeliveryCreate'
  className: 'span12'

  events:
    'change #courier'           : 'changeCourierIcon'
    'change #dispatch'          : 'toggleGuides'
    'click #add-new-supplier'   : 'addNewSupplier'
    'click #submit-new-supplier': 'addNewSupplier'
    'click #add-new-origin'     : 'addNewOrigin'
    'click #submit-new-origin'  : 'addNewOrigin'
    'change #brand'             : 'changeBrand'
    'change #season'            : 'changeSeason'
    'change #code'              : 'changeCode'

  initialize: ->
    @model = new App.Models.Delivery()
    @suppliers   = App.deliveries.pluckDistinct('supplier')
    @origins     = App.deliveries.pluckDistinct('origin')
    @brands     = App.items.pluckDistinct('brand')
    @formHelper = new App.Mixins.Form()

  render: ->
    $(@el).html(@template(suppliers: @suppliers, origins: @origins, brands: @brands))
    this

  changeCourierIcon: (e) ->
    courier = $('#courier').val()
    if courier == "Seleccione una Empresa" then return $('#courier-logo')[0].src = "/assets/rails.png"
    $('#courier-logo')[0].src = "/assets/#{courier}.png"
    this

  toggleGuides: (e) ->
    dispatch = $('#dispatch').val()
    if dispatch == "DUA"
      $('#guide2').removeClass('hide')
      $('#guide3').removeClass('hide')
      $('#cargo2').removeClass('hide')
      $('#cargo3').removeClass('hide')
      return this
    else
      if $('#guide2').hasClass('hide')
        return this
      else
        $('#guide2').addClass('hide')
        $('#guide3').addClass('hide')
        $('#cargo2').addClass('hide')
        $('#cargo3').addClass('hide')
        return this

  addNewSupplier: (e) ->
    e.preventDefault()
    @formHelper.modalToSelect("#add-new-supplier-modal", "#new-supplier", "#supplier")
    this

  addNewOrigin: (e) ->
    e.preventDefault()
    @formHelper.modalToSelect("#add-new-origin-modal", "#new-origin", "#origin")
    this

  changeBrand: (e) ->
    brand = $('#brand').val()
    if brand == "Seleccione una Marca"
      @resetSelect('#season', 'Seleccione una Temporada')
      @resetSelect('#code', 'Seleccione un Artículo')
      $('#entry').val('')
      return
    seasons = App.items.pluckDistinct('season', {brand: brand})
    $('#season option').remove()
    for season in seasons
      $('#season').append("<option>#{season}</option>")
    @changeSeason()
    this

  changeSeason: (e) ->
    season = $('#season').val()
    brand = $('#brand').val()
    $('#code option').remove()
    codes = App.items.pluckDistinct('code', {brand: brand, season: season})
    for code in codes
      $('#code').append("<option>#{code}</option>")
    @changeCode()
    this

  changeCode: (e) ->
    code    = $('#code').val()
    entry   = App.items.pluckDistinct('entry', {code: code})
    $('#entry').val(entry)
    this

  resetSelect: (id, text) ->
    $(id + " option").remove()
    $(id).append("<option>#{text}</option>")
    $(id).val(text)
    this
