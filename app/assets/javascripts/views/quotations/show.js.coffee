class App.Views.ShowQuotation extends Backbone.View
  template: JST['quotations/show']
  className: ->
    "row-fluid quotation color#{@model.id % 2}"
  name: 'ShowQuotations'

########################################################################################################################

################################################ $ Events $ ############################################################
  events:
    'click .close'                    : 'destroyQuotation'
    'click label:contains("Detalle")' : 'toggleSection'
    'click #select-quotation'         : 'authorizeQuotation'
    'click'                           : 'selected'
########################################################################################################################

################################################ $ Events $ ############################################################
  initialize: (options) ->
    @flip = 1
    @model.set 'supplier', App.suppliers.get(@model.get('supplier_id')).get('name')
    @listenTo App.vent, "show:select-quotation-button", => @model.set('can_be_selected', true)
    @listenTo App.vent, "hide:select-quotation-button", =>
      @model.set('can_be_selected', false)
      @$('.close-quotation').show()
    @listenTo App.vent, "selected:quotation:success", (cid) =>
      unless cid == @model.cid then @$('.select-quotation-button').slideUp('slow')
      $(@el).removeClass('selected')
    @listenTo App.vent, "purchase:request:authorized:success", => @model.set('can_be_selected', false)
########################################################################################################################

################################################ $ Render $ ############################################################
  render: ->
    $(@el).hide().html(@template(model: @model, state: @state)).fadeIn('slow')
    @$('.detail').html(@model.get('detail'))
    if @model.get('can_be_selected') == true then @$('.close-quotation').hide()
    this
########################################################################################################################

########################################### $ Destroy Quotation $ ######################################################
  destroyQuotation: (e) ->
    e.preventDefault() if e?
    result = confirm("Esta seguro que desea eliminar esta cotización?")
    if result
      App.vent.trigger "remove:createQuotation:success", @model
      @model.destroy()
      @remove()
########################################################################################################################

############################################ $ Toggle Section $ ########################################################
  toggleSection: ->
    @flip = @flip + 1
    @$('section').slideToggle('slow')
    if @flip % 2 == 0
      @$('label:contains("Detalle")').html('Detalle <i class="icon-filter icon-white"></i>')
    else
      @$('label:contains("Detalle")').html('Detalle')
    this
########################################################################################################################

############################################ $ Toggle Section $ ########################################################
  selected: (e) ->
    return if @model.get('can_be_selected') == false
    App.vent.trigger "selected:quotation:success", @model.cid
    $(@el).addClass('selected')
    @$('.select-quotation-button').slideDown('slow')
########################################################################################################################

############################################# $ Show Button $ ##########################################################
  showButton: ->
    @$('.select-quotation-button').show()
    this
########################################################################################################################

######################################### $ Authorize Quotation $ ######################################################
  authorizeQuotation: (e) ->
    e.preventDefault()
    @model.save {selected: 'true'}, success: =>
      @model.set('can_be_selected', false)
      App.vent.trigger "selected:quotation:success", @model.cid
      App.vent.trigger "purchase_request:authorized:success", @model
      @remove()
    this
########################################################################################################################

########################################### $ Hide Close Button $ ######################################################
  hideCloseButton: (e) ->
    @$('.close-quotation').hide()
    this
########################################################################################################################

########################################### $ Approve Quotation $ ######################################################
  approveQuotation: ->
    setTimeout =>
      @$('.authorized').show()
    , 600
    $(@el).effect("bounce", { times:10 }, 1000)
    @$('.select-quotation-button').remove()
    @$('#create-purchase-order').show()
    this
########################################################################################################################