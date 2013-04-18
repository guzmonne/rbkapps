class App.Views.SupplierIndex extends Backbone.View
  template: JST['suppliers/index']
  className: 'row-fluid'
  name: 'IndexSupplier'
########################################################################################################################

################################################# $ Events $ ###########################################################
  events:
    'click #fetch-suppliers'     : 'fetchSuppliers'
    'click #new-supplier'        : 'newSupplier'
    'click th'                   : 'sortSuppliers'
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

################################################## $ Sort $ ############################################################
  sortSuppliers: (e) ->
    sortVar =  e.currentTarget.dataset['sort']
    type    =  e.currentTarget.dataset['sort_type']
    oldVar  =  @collection.sortVar
    @removeChevron()
    if sortVar == oldVar
      if @collection.sortMethod == 'lTH'
        @sort(sortVar, 'hTL', 'down', type )
      else
        @sort(sortVar, 'lTH', 'up', type )
    else
      @sort(sortVar, 'lTH', 'up', type, oldVar )

  sort: (sortVar, method, direction, type, oldVar = null ) ->
    if oldVar == null then oldVar = sortVar
    if direction == 'up'
      $("th[data-sort=#{sortVar}]").append( '<i class="icon-chevron-up pull-right"></i>' )
    else
      $("th[data-sort=#{sortVar}]").append( '<i class="icon-chevron-down pull-right"></i>' )
    @update(type, sortVar, method)

  removeChevron: ->
    @$(".icon-chevron-up").remove()
    @$(".icon-chevron-down").remove()

  update: (type, sortVar, method) ->
    oldSortVarType      = @collection.sortVarType
    oldSortVar          = @collection.sortVar
    oldSortMethod       = @collection.sortMethod
    @collection = App.suppliers
    if type? and sortVar? and method?
      @collection.setSortVariables(type, sortVar, method)
    else
      @collection.setSortVariables(oldSortVarType, oldSortVar, oldSortMethod)
    App.vent.trigger 'update:suppliers:success'
    @collection.sort().each(@appendSuppliers)
########################################################################################################################