class App.Views.InvoiceItemCreate extends Backbone.View
  template: JST['invoice_items/create']
  name: 'InvoiceItemCreate'
  className: 'white-box'

  events:
    'click #toggle-items-form'                 : 'toggleItemsForms'
    'click #search-items'                      : 'toggleItemsForms'
    'click #add-new-brand'                     : 'addNewItemElement'
    'click #add-new-season'                    : 'addNewItemElement'
    'click #add-new-entry'                     : 'addNewItemElement'
    'click #add-new-item'                      : 'addNewItem'
    'change #searched-item-code'               : 'displaySearchedItem'
    'click #add-searched-item'                 : 'addSearchedItem'
    'focus #searched-item-code'                : 'typeAheadItem'
#######################################################################################################################

################################################### $ Initialize $ ####################################################
  initialize: (options) ->
    @items = new App.Collections.Items
    if options == undefined
      @currentItems = new App.Collections.Items
    else
      @currentItems = options.currentItems
    @listenTo App.vent, 'remove:invoice_item:success', (model) =>
      return if @items.length == 0
      return unless @$('#searched-item-code').data('typeahead')?
      @items.add(model)
      @$('#searched-item-code').data('typeahead').source = => @items.pluck('code')
#######################################################################################################################

###################################################### $ Render $ #####################################################
  render: ->
    $(@el).html(@template())
    this
#######################################################################################################################

################################################### $ Add New Item $ ##################################################
  addNewItem: (e) ->
    e.preventDefault()
    model = new App.Models.InvoiceItem()
    attributes =
      code      : @$('#code').val()
      brand     : @$('#brand').val()
      season    : @$('#season').val()
      entry     : @$('#entry').val()
      quantity  : @$('#quantity').val()
    model.set(attributes)
    $('.new_item').val('')
    $('#quantity').val('1')
    @addItem(model)
    $('#code').focus()
    this
#######################################################################################################################

################################################## $ Type Ahead Item $ #################################################
  typeAheadItem: ->
    if @items.length == 0
      @items.fetch success: =>
        @$('#searched-item-code').removeClass('loading')
        @$('#searched-item-code').typeahead source: =>
          if @currentItems.length > 0
            @currentItems.each (model) => @items.remove(model)
          @items.pluck("code")
    this
########################################################################################################################

####################################################### $ Add Item $ ###################################################
  addItem: (invoice_item, afterElement = null) ->
    App.vent.trigger "add:invoice_item:success", invoice_item
    itemView =  new App.Views.InvoiceItem(model: invoice_item)
    App.pushToAppendedViews(itemView)
    if afterElement == null
      $('#item-form-row').after(itemView.render().el)
    else
      $(afterElement).after(itemView.render().el)
########################################################################################################################

################################################# $ Add Searched Item $ ################################################
  addSearchedItem: (e) ->
    e.preventDefault()
    code = @$('#searched-item-code').val()
    item = @items.where(code: code)[0]
    return if item ==  undefined
    item.set('quantity', @$('#search_quantity').val())
    @addItem(item)
    @items.remove(item)
    items = @items.pluck('code')
    @$('#searched-item-code').val('')
    @displaySearchedItem()
    @$('#searched-item-code').typeahead(source: items)
########################################################################################################################

################################################ $ Display Searched Item $ #############################################
  displaySearchedItem: (e) ->
    code = @$('#searched-item-code').val()
    if code == ''
      @$('#searched-item-brand').text('')
      @$('#searched-item-season').text('')
      @$('#searched-item-entry').text('')
      @$('#search_quantity').val('1')
      return
    item = @items.where(code: code)[0]
    return if item ==  undefined
    @$('#searched-item-brand').text(item.get('brand'))
    @$('#searched-item-season').text(item.get('season'))
    @$('#searched-item-entry').text(item.get('entry'))
########################################################################################################################

################################################ $ Toggle Item Forms $ #################################################
  toggleItemsForms: (e) ->
    e.preventDefault() if e?
    @$('#item-form-row').toggle().find('#code').focus()
    @$('#search-items').toggle()
    @$('#item-search-row').toggle().find('#searched-item-code').focus()
    @$('#toggle-items-form').toggle()
    this
########################################################################################################################

################################################## $ Close Item Form $ #################################################
  closeItemForm: (e) ->
    e.preventDefault() if e?
    @$('#item-form-row').toggle()
  closeSearchForm: (e) ->
    e.preventDefault() if e?
    @$('#item-search-row').toggle().find('#searched-item-code').focus()
########################################################################################################################

################################################ $ Add New Item Element $ ##############################################
  addNewItemElement: (e) ->
    e.preventDefault()
    l = e.currentTarget.id.split('-').length
    element = e.currentTarget.id.split('-')[l-1]
    if @$("#new-" + element).hasClass('hide')
      @$("#" + element).toggle('fast')
      @$("#new-" + element).removeClass('hide').hide().toggle('fast')
      @$("#add-new-" + element).html('<i class="icon-ok icon-white"></i>')
      @$("#new-" + element).focus()
    else
      text = @$("#new-" + element).val()
      if text == ''
        @$("#" + element).toggle('fast').focus()
      else
        @$("#" + element).toggle('fast').focus().append("<option>#{text}</option>").val(text)
      @$("#add-new-" + element).html('<i class="icon-plus icon-white"></i>')
      @$("#new-" + element).toggle('fast').addClass('hide').val('')
    this
########################################################################################################################

################################################## $ Reset Items $ #####################################################
  resetItems: ->
    @items = new App.Collections.Items
    @$('#searched-item-code').addClass('loading')

