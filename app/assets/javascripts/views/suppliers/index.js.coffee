class App.Views.SupplierIndex extends Backbone.View
  template: JST['suppliers/index']
  className: 'row-fluid'
  name: 'IndexSupplier'
########################################################################################################################

################################################# $ Events $ ###########################################################
  events:
    'click #fetch-suppliers'     : 'fetchSuppliers'
    'click #new-supplier'        : 'newSupplier'
########################################################################################################################

############################################### $ Initialize $ #########################################################
  initialize: ->
    @fetchSuppliers = _.debounce(@fetchSuppliers, 300);
    @collection = App.suppliers
    @listenTo App.vent, "supplier:create:success", (model) => @prependSuppliers(model)
########################################################################################################################

################################################# $ Render $ ###########################################################
  render: ->
    $(@el).html(@template(model: @model))
    @collection.each(@appendSuppliers)
    this
########################################################################################################################

############################################ $ Append Suppliers $ ######################################################
  appendSuppliers: (model) =>
    view = new App.Views.Supplier(model: model)
    App.pushToAppendedViews(view)
    @$('#suppliers').append(view.render().el)
    this
########################################################################################################################

############################################ $ Append Suppliers $ ######################################################
  prependSuppliers: (model) =>
    view = new App.Views.Supplier(model: model)
    App.pushToAppendedViews(view)
    @$('#suppliers').prepend(view.render().el)
    this
########################################################################################################################

############################################## $ New Supplier $ ########################################################
  newSupplier: (model) =>
    view = new App.Views.SupplierCreate(model: model)
    App.pushToAppendedViews(view)
    @$('#new-supplier-form').append(view.render().el)
    this
########################################################################################################################

############################################## $ New Supplier $ ########################################################
  fetchSuppliers: (e) ->
    e.preventDefault()
    App.vent.trigger 'update:suppliers:success'
    @$('#fetch-suppliers').html('<i class="icon-load"></i>  Actualizando').addClass('loading')
    App.suppliers.fetch success: =>
      @$('#fetch-suppliers').html('Actualizar').removeClass('loading')
      App.suppliers.each(@appendSuppliers)
    this
########################################################################################################################
