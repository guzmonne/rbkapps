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
    'click #submit-new-origin': 'addNewOrigin'
  initialize: ->
    @model = new App.Models.Delivery()
    @suppliers   = App.items.pluckDistinct('supplier')
    @origins     = App.items.pluckDistinct('origin')
    @formHelper = new App.Mixins.Form()

  render: ->
    $(@el).html(@template(suppliers: @suppliers, origins: @origins))
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
      return this
    else
      if $('#guide2').hasClass('hide') && $('#guide2').hasClass('hide')
        return this
      else
        $('#guide2').addClass('hide')
        $('#guide3').addClass('hide')
        return this

  addNewSupplier: (e) ->
    e.preventDefault()
    @formHelper.modalToSelect("#add-new-supplier-modal", "#new-supplier", "#supplier")
    this

  addNewOrigin: (e) ->
    e.preventDefault()
    @formHelper.modalToSelect("#add-new-origin-modal", "#new-origin", "#origin")
    this

