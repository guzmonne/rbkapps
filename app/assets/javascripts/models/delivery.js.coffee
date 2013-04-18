class App.Models.Delivery extends Backbone.Model
  urlRoot: '/api/deliveries'

  initialize: (model) ->
    @invoices = new App.Collections.Invoices()

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
