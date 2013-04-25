class App.Views.ComexReports extends Backbone.View
  template: JST['reports/comex/main']
  itemsStatus: JST['reports/comex/items_status']


  events:
    'click ul.dropdown-menu li a'     : 'customSelect'
    'keydown .no_typing'              : 'noTyping'
    'keyup .no_typing'                : 'noTyping'
    'click #run_report'               : 'runReport'

  initialize: ->
    @reportName = ''
  render: ->
    $(@el).html(@template())
    this

  customSelect: (e) ->
    text = e.currentTarget.text
    id = e.currentTarget.dataset["id"]
    switch id
      when 'report_name'
        @reportName = e.currentTarget.dataset['reportName']
        @$('#report_name').val(text)
        @showFilters()
        @$('#report').hide()
        break
      when 'brand', 'season', 'entry'
        @$('#' + id).val(text)
        break
    this

  showFilters: ->
    @$('.filter').fadeOut('slow')
    @$('#' + @reportName).fadeIn('slow')
    this

  noTyping: (e) ->
    e.preventDefault()
    id = e.currentTarget.id
    @$('#' + id).val('')
    this

  runReport: (e) ->
    e.preventDefault()
    App.vent.trigger "new:report:success"
    switch @reportName
      when 'items_status'
        @$('#report').show().html(@itemsStatus())
        @itemsStatusReport()
        break
    this

  itemsStatusReport: ->
    if @$('#brand').val() == '' then brand = null else brand = @$('#brand').val()
    if @$('#season').val() == '' then season = null else season = @$('#season').val()
    if @$('#entry').val() == '' then entry = null else entry = @$('#entry').val()
    items = new App.Collections.Items()
    items.fetch success: =>
      if brand == null
        if season == null
          if entry == null
            return @appendItems(items)
          else
            array = items.where({entry: entry})
            return @appendItems(array, true)
        else
          if entry == null
            array = items.where({season: season})
            return @appendItems(array, true)
          else
            array = items.where({season: season ,entry: entry})
            return @appendItems(array, true)
      else
        if season == null
          if entry == null
            array = items.where({brand: brand})
            return @appendItems(array, true)
          else
            array = items.where({brand: brand, entry: entry})
            return @appendItems(array, true)
        else
          if entry == null
            array = items.where({brand: brand, season: season})
            return @appendItems(array, true)
          else
            array = items.where({brand: brand, season: season ,entry: entry})
            return @appendItems(array, true)
    this

  appendItems: (items, array = false) ->
    items.forEach (item) =>
      if array == false
        view = new App.Views.Item(model:item, collection: items)
      else
        view = new App.Views.Item(model:item)
      App.pushToAppendedViews(view)
      @$('#items').append(view.render().el)
      view.removeHideButton()
      if App.colHelper.colHasDupes( _.map(items, (i) -> return i.get('code') )).indexOf(item.get('code')) > -1 then view.rowDangerClass()



