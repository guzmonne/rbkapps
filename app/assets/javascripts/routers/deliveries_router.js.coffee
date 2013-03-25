class App.Routers.Delivery extends Backbone.Router

  initialize: ->
    @listenTo App.vent, "deliveries:show", (model) => @setDelivery(model)

  routes:
    'deliveries/new'  : 'create'
    'deliveries/index': 'index'
    'deliveries/show/:id'  : 'show'

  setDelivery: (model) ->
    Backbone.history.navigate "deliveries/show/#{model.get('id')}", true

  create: ->
    view = new App.Views.Loading()
    App.setAndRenderContentViews([view])
    if App.user.get("comex") == true or App.user.get("admin") == true
      view = new App.Views.DeliveryCreate()
      App.setAndRenderContentViews([view])
      return this
    else
      Backbone.history.navigate('home', trigger: true)
      return this

  index: ->
    view = new App.Views.Loading()
    App.setAndRenderContentViews([view])
    if App.user.get("comex") == true or App.user.get("admin") == true
      view = new App.Views.DeliveryIndex()
      App.setAndRenderContentViews([view])
      return this
    else
      Backbone.history.navigate('home', trigger: true)
    this

  show: (id) ->
    @delivery = new App.Models.Delivery
    view = new App.Views.Loading()
    App.setAndRenderContentViews([view])
    if App.user.get("comex") == true or App.user.get("admin") == true
      new App.Models.Delivery(id: id).fetch success: (model, data) =>
        @delivery.set data.delivery
        if data.invoices.length > 0
          for i in [0..data.invoices.length - 1]
            invoice = new App.Models.Invoice
            invoice.set(data.invoices[i].invoice)
            if data.invoices[i].invoice_items.length > 0
              for j in [0..data.invoices[i].invoice_items.length - 1]
                invoice_item = new App.Models.InvoiceItem()
                invoice_item.set(data.invoices[i].invoice_items[j])
                invoice.invoice_items.add(invoice_item)
              @delivery.invoices.add(invoice)
        view = new App.Views.DeliveryShow(model: @delivery)
        App.setAndRenderContentViews([view])
        return this
    else
      Backbone.history.navigate('home', trigger: true)
    this