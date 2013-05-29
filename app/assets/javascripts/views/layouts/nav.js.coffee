class App.Views.Nav extends Backbone.View
  template: JST['layout/nav']
  tagName: "nav"
  className: "navbar-inner"

  events:
    'click #nav-home'                   : 'home'
    'click #sign-out'                   : 'signOut'
    'click #nav-user'                   : 'home'
    'click #nav-new-user'               : 'createUser'
    'click #nav-purchase-request'       : 'createPurchaseRequest'
    'click #nav-index-purchase-request' : 'indexPurchaseRequest'
    'click #nav-team'                   : 'indexTeams'
    'click #nav-new-team'               : 'createTeam'
    'click #nav-new-item'               : 'createItem'
    'click #nav-item'                   : 'indexItem'
    'hover .hover-white'                : 'whiteShirt'
    'click #nav-deliveries'             : 'deliveriesIndex'
    'click #nav-new-delivery'           : 'deliveryCreate'
    'click #nav-invoice'                : 'invoiceIndex'
    'click #nav-users'                  : 'usersIndex'
    'click #nav-comex-reports'          : 'comexReports'
    'click #nav-service-request'        : 'createServiceRequest'
    'click #nav-service-request-index'  : 'indexServiceRequest'
    'click #nav-suppliers'              : 'suppliersIndex'
    'click #nav-purchase_orders'        : 'purchaseOrdersIndex'
    'click #nav-categories'             : 'categoriesIndex'

  render: ->
    $(@el).html(@template(user: @model))
    if @model.get('admin') ==  true then @$('.admin').show()
    if @model.get('comex') == true then @$('.comex').show()
    if @model.get('compras') == true then @$('.compras').show()
    this

  home: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'home', true
    this

  signOut: (e) ->
    e.preventDefault()
    App.signOut()
    Backbone.history.navigate 'sign_in', trigger:true
    this

  createUser: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'users/new', trigger:true
    this

  createPurchaseRequest: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'purchase_request/new', trigger: true
    this

  indexPurchaseRequest: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'purchase_request/index', trigger: true
    this

  indexTeams: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'teams/index', trigger: true
    this

  createTeam: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'teams/new', trigger: true
    this

  createItem: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'items/new', trigger: true
    this

  indexItem: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'items/index', trigger: true
    this

  whiteShirt: (e) ->
    $(e.currentTarget).find('i').toggleClass('t_shirt-white')
    this

  deliveriesIndex: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'deliveries/index', trigger: true
    this

  deliveryCreate: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'deliveries/new', trigger: true
    this

  invoiceIndex: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'invoices/index', trigger: true

  usersIndex: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'users/index', trigger: true

  comexReports: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'comex/reports', trigger: true

  createServiceRequest: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'service_requests/create', trigger: true

  indexServiceRequest: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'service_requests/index', trigger: true

  suppliersIndex: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'suppliers/index', trigger: true

  purchaseOrdersIndex: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'purchase_order/index', trigger: true

  categoriesIndex: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'categories/index', trigger: true
