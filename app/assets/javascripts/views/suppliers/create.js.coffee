class App.Views.SupplierCreate extends Backbone.View
  template: JST['suppliers/create']
  name: 'Create Supplier'
  className: "row-fluid supplier"

################################################# $ Events $ ###########################################################
  events:
    'click #create-new-method_of_payment'                 : 'createNewMethod'
    'click #cancel-new-method_of_payment'                 : 'createNewMethod'
    'click #submit-new-method_of_payment'                 : 'createMethod'
    'click .close'                                        : 'removeSupplier'
    'click #save-supplier'                                : 'saveSupplier'
########################################################################################################################

############################################### $ Initialize $ #########################################################
  initialize: ->
    @model = new App.Models.Supplier()
########################################################################################################################

################################################# $ Render $ ###########################################################
  render: ->
    $(@el).hide().html(@template()).fadeIn('slow')
    this
########################################################################################################################

############################################ $ Create New Method $ #####################################################
  createNewMethod: (e) ->
    e.preventDefault() if e?
    @$('#new-method_of_payment-input').toggle()
    @$('#method_of_payment').toggle()
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
      @$('#method_of_payment').append("<option>#{newMethod}</option>")
      @$('#method_of_payment').val(newMethod)
    this
########################################################################################################################

############################################### $ Save Quotation $ #####################################################
  saveSupplier: (e) ->
    e.preventDefault()
    attributes =
      supplier:
        address             : @$('#address').val()
        name                : @$('#name').val()
        phone               : @$('#phone').val()
        email               : @$('#email').val()
        method_of_payment   : @$('#method_of_payment').val()
        contact             : @$('#contact_name').val()
        contact_phone       : @$('#contact_phone').val()
        contact_email       : @$('#contact_email').val()
        entry               : @$('#entry').val()
    @model.save attributes, success: =>
      App.vent.trigger "supplier:create:success", @model
      @remove()
########################################################################################################################

############################################### $ Remove Supplier $ ###################################################
  removeSupplier: (e) ->
    e.preventDefault() if e?
    result = confirm("Esta seguro que desea finalizar la creación de este Proveedor?")
    if result
      App.vent.trigger "remove:createSupplier:success", @model
      @remove()
########################################################################################################################