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
    'click .currency'                                     : 'changeCurrency'
    'click #create-new-method_of_payment'                 : 'createNewMethod'
    'click #cancel-new-method_of_payment'                 : 'createNewMethod'
    'click #submit-new-method_of_payment'                 : 'createMethod'
    'change .supplier_id'                                 : 'setMethodOfPayment'
############################################### $ Initialize $ #########################################################
  initialize: ->
    @shown  = 0
    @flip   = 1
########################################################################################################################

################################################# $ Render $ ###########################################################
  render: ->
    $(@el).hide().html(@template()).fadeIn('slow')
    @$('.supplier').focus()
    this
########################################################################################################################

############################################ $ Create New Method $ #####################################################
  createNewMethod: (e) ->
    e.preventDefault() if e?
    @$('#new-method_of_payment-input').toggle()
    @$('.method_of_payment').toggle()
    @$('#create-new-method_of_payment').toggle()
    @$('#submit-new-method_of_payment').toggle()
    @$('#cancel-new-method_of_payment').toggle()
    this
########################################################################################################################

############################################# $ Create Method $ ########################################################
  createMethod: (e) ->
    e.preventDefault() if e?
    newMethod = @$('#new-method_of_payment-input').val()
    if newMethod == "" then return @createNewMethod()
    @$('#submit-new-method_of_payment').val('')
    model = new App.Models.FormHelper
    attributes =
      form_helper:
        column       : 'method_of_payment'
        value        : newMethod
    model.save attributes, success: =>
      @$('#new-method_of_payment-input').val('')
      @createNewMethod()
      @$('.method_of_payment').append("<option>#{newMethod}</option>")
      @$('.method_of_payment').val(newMethod)
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
      purchase_request_id : @model.get('purchase_request_id')
      supplier_id         : @$('.supplier_id').val()
      method_of_payment   : @$('.method_of_payment').val()
      detail              : @$('#quotation_detail').val()
      total_net           : @$('.total_net').val()
      iva                 : @$('.iva').val()
      dollars             : @model.get('dollars')
    @model.save attributes, success: =>
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
########################################################################################################################

################################################ $ Change Currency $ ###################################################
  changeCurrency: ->
    @flip = @flip + 1
    if @flip % 2 == 0
      @$('.add-on').text('USD')
      @$('.currency').text('$')
      @model.set('dollars', true)
    else
      @$('.add-on').text('$')
      @$('.currency').text('USD')
      @model.set('dollars', false)
    this
########################################################################################################################

########################################### $ Set Method of Payment $ ##################################################
  setMethodOfPayment: (e) ->
    @$('.method_of_payment').val(App.suppliers.get(@$('.supplier_id').val()).get('method_of_payment'))
    this
########################################################################################################################