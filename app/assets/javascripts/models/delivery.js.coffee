class App.Models.Delivery extends Backbone.Model
  urlRoot: '/api/deliveries'

  initialize: (model) ->
    @invoices = new App.Collections.Invoices()
    @dh = new App.Mixins.DateHelper

  fetchSubCollections: (options) ->
    if @invoices.length == 0
      @invoices.fetch data: {delivery_id: @id}, success: =>
        if @items.length == 0
          @items.fetch data: {delivery_id: @id}, success: =>
            if options.success then return options.success(@invoices, @items)
            return this
        else
          if options.success then return options.success(@invoices, @items)
          return this
    else
      if @items.length == 0
        @items.fetch data: {delivery_id: @id}, success: =>
          if options.success then return options.success(@invoices, @items)
          return this
      else
        if options.success then return options.success(@invoices, @items)
        return this

  guides: ->
    g = "#{@get('guide')}"
    unless @get('guide2') == '' then g = "#{g} #{@get('guide2')}"
    unless @get('guide3') == '' then g = "#{g} #{@get('guide3')}"
    return g

  daysToDispatch: ->
    return @dh.dateBusDiff(@get('arrival_date'), @get('delivery_date'))

  update: (attributes, options) ->
    $.ajax
      url: "/api/deliveries/#{attributes["delivery"]["id"]}"
      data: attributes
      type: 'PUT'
      dataType: 'json'
      success: (data, status, response) =>
        @set(data)
        options.success(data, status, response) if options.success()?
      error: (data, status, response) =>
        options.error(data, status, response) if options.error()?

  destroy: ->
    $.ajax
      url: "/api/deliveries/#{@id}"
      data: {id: @id}
      type: 'DELETE'
      dataType: 'json'
