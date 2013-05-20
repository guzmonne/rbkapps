class App.Views.ComexReports extends Backbone.View
  template: JST['reports/comex/main']
  daysToDispatch: JST['reports/comex/days_to_dispatch']

  events:
    'click ul.dropdown-menu li a'     : 'customSelect'
    'keydown .no_typing'              : 'noTyping'
    'keyup .no_typing'                : 'noTyping'
    'click .run_report'               : 'runReport'

  initialize: ->
    @fh = new App.Mixins.Form

  render: ->
    $(@el).html(@template())
    this

  customSelect: (e) ->
    text = e.currentTarget.text
    id = e.currentTarget.dataset["id"]
    @$('#import_to_xls').show()
    switch id
      when 'report_name'
        #@reportName = e.currentTarget.dataset['reportName']
        #@controller = e.currentTarget.dataset['controller']
        @$('#report_name').val(text)
        @showFilters()
        @$('#report').html('')
        #@$('#import_to_xls').attr('href', "/api/#{@controller}/#{@reportName}.xls")
        break
      when 'brand', 'season', 'entry'
        @$('#' + id).val(text)
        break
    this

  showFilters: ->
    @$('.filter').hide()
    @$('#' + @reportName).fadeIn('slow')
    this

  noTyping: (e) ->
    e.preventDefault()
    id = e.currentTarget.id
    @$('#' + id).val('')
    this

  runReport: (e) ->
    e.preventDefault()
    @$('#notice').html('')
    App.vent.trigger "new:report:success"
    App.pushToAppendedViews(view)
    switch @reportName
      when 'items_status'
        if @$('#brand').val() == '' then brand = null else brand = @$('#brand').val()
        if @$('#season').val() == '' then season = null else season = @$('#season').val()
        if @$('#entry').val() == '' then entry = null else entry = @$('#entry').val()
        view = new App.Views.ItemStatusComexReport(brand: brand, season:season, entry:entry)
        App.pushToAppendedViews(view)
        @$('#report').html(view.render().el)
        break
      when 'days_to_dispatch'
        view = new App.Views.DaysToDispatchComexReport()
        App.pushToAppendedViews(view)
        @$('#report').html(view.render().el)
    this


