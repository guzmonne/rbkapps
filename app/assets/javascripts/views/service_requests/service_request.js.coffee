class App.Views.ServiceRequest extends Backbone.View
  template: JST['service_request/service_request']
  tagName: 'tr'
  name: 'ServiceRequest'

  events:
    'dblclick': 'showServiceRequest'

  initialize: ->
    @category = App.categories.get(@model.get('category_id'))
    @model.set('category1', @category.get('category1'))
    if @category.get('category2') == "SSC"
      @model.set('category2', "***")
    else
      @model.set('category2', @category.get('category2'))
    if @category.get('category3') == "STC"
      @model.set('category3', "***")
    else
      @model.set('category3', @category.get('category3'))
    @model.set('creator', App.users.getNameFromId(@model.get('creator_id')))
    if @model.get("title") == "" then @model.set('title', "***")
    @listenTo App.vent, 'update:purchase_requests:success', => @remove()

  render: ->
    $(@el).html(@template(model: @model))
    unless @model.get("status") == "Cerrado" or @model.get("status") == "Cerrado y Verificado"
      switch @model.get("priority")
        when "Urgente"
          @$('.priority').append('  <label class="label label-important pull-right"><i class="icon-warning-sign icon-white"></i></label>')
          @$('.priority').addClass('important-text')
          @$('.priority').parent().addClass('row-danger')
          break
        when "Muy Alta"
          @$('.priority').append('  <label class="label label-important pull-right"><i class="icon-exclamation-sign icon-white"></i></label>')
          break
        when "Alta"
          @$('.priority').append('  <label class="label label-warning pull-right"><i class="icon-exclamation-sign icon-white"></i></label>')
          break
        when "Media"
          @$('.priority').append('  <label class="label label-info pull-right"><i class="icon-exclamation-sign icon-white"></i></label>')
          break
        when "Baja"
          @$('.priority').append('  <label class="label label-success pull-right"><i class="icon-exclamation-sign icon-white"></i></label>')
          break
    switch @model.get("status")
      when "Nuevo"
        @$('.status').addClass('label-info')
        break
      when "Abierto"
        @$('.status').addClass('label-warning')
        break
      when "Pendiente"
        @$('.status').addClass('label-important')
        break
      when "Cerrado"
        @$('.status').addClass('label-success')
        break
    this

  showServiceRequest: ->
    view = new App.Views.ServiceRequestsShow(model: @model)
    Backbone.history.navigate "service_requests/show/#{@model.id}"
    App.setAndRenderContentViews([view])