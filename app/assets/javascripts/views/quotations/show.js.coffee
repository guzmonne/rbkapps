class App.Views.ShowQuotation extends Backbone.View
  template: JST['quotations/show']
  className: 'row-fluid quotation'
  name: 'ShowQuotations'

########################################################################################################################

################################################ $ Events $ ############################################################
  events:
    'click .close'                    : 'destroyQuotation'
    'click label:contains("Detalle")' : 'toggleSection'
########################################################################################################################

################################################ $ Events $ ############################################################
  initialize: ->
    @flip = 1
########################################################################################################################

################################################ $ Render $ ############################################################
  render: ->
    $(@el).hide().html(@template(model: @model)).fadeIn('slow')
    @$('.detail').html(@model.get('detail'))
    console.log "render"
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
