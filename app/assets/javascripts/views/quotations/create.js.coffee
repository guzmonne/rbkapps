class App.Views.CreateQuotation extends Backbone.View
  template: JST['quotations/create']
  name: 'AddQuotation'
  className: "row-fluid quotation"

  events:
    'focus #quotation_detail'                             : 'showWYSIHTML5'
    'click .close'                                        : 'removeQuotation'
    'change .tot'                                         : 'updateTotal'
    'change .total_net'                                   : 'updateIVA'
    'click label:contains("I.V.A")'                       : 'updateIVA'
    'click #save-new-quotation'                           : 'saveQuotation'
############################################### $ Initialize $ #########################################################
  initialize: ->
    @shown = 0
########################################################################################################################

################################################# $ Render $ ###########################################################
  render: ->
    $(@el).hide().html(@template()).fadeIn('slow')
    @$('.supplier').focus()
    this
########################################################################################################################

######################################## $ Create Purchase Request $ ###################################################
  showWYSIHTML5: ->
    return if @shown == 1
    @$('#quotation_detail').wysihtml5()
    @shown = 1
    this
########################################################################################################################

############################################### $ Save Quotation $ #####################################################
  saveQuotation: (e) ->
    e.preventDefault()
    attributes =
      supplier_id       : @$('.supplier').val()
      method_of_payment : @$('.method_of_payment').val()
      detail            : @$('#quotation_detail').val()
      total_net         : @$('.total_net').val()
      iva               : @$('.iva').val()
    @model.set(attributes)
    App.vent.trigger "quotation:create:success", @model
    App.closeView(this)
########################################################################################################################

############################################### $ Remove Quotation $ ###################################################
  removeQuotation: (e) ->
    e.preventDefault() if e?
    result = confirm("Esta seguro que desea eliminar esta cotización?")
    if result
      App.vent.trigger "remove:createQuotation:success", @model
      @remove()
########################################################################################################################

############################################### $ Remove Quotation $ ###################################################
  updateTotal: ->
    @$('.total_net').val( parseFloat(@$('.total_net').val()).toFixed(2) )
    @$('.iva').val( parseFloat(@$('.iva').val()).toFixed(2) )
    @$('.total').val((parseFloat(@$('.total_net').val()) + parseFloat( @$('.iva').val())).toFixed(2))
    this
########################################################################################################################

############################################### $ Remove Quotation $ ###################################################
  updateIVA: ->
    @$('.iva').val((parseFloat(@$('.total_net').val()) * 0.22).toFixed(2))
    @$('.total').val((parseFloat(@$('.total_net').val()) + parseFloat( @$('.iva').val())).toFixed(2))
    this