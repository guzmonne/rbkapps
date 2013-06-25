class App.Views.ServiceRequestsReport extends Backbone.View
  template: JST['reports/service/report']

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
    #@$('#import_to_xls').show()
    switch id
      when 'report_name'
        @reportName = e.currentTarget.dataset['reportName']
        @$('#report_name').val(text)
        @showFilters()
        @$('#report').html('')
        #@$('#import_to_xls').attr('href', "/comex_reports.xls?report=#{@reportName}")
        break
    this

  showFilters: ->
    @$('.filter').hide()
    @$('.span7').hide()
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
      when 'closed_services'
        to = @$('#to_date').val()
        from = @$('#from_date').val()
        view = new App.Views.ClosedServices(to: to, from: from)
        App.pushToAppendedViews(view)
        @$('#report').html(view.render().el)
      when 'order_evolution'
        to = @$('#to_date_2').val()
        from = @$('#from_date_2').val()
        view = new App.Views.OrderEvolution(to: to, from: from)
        App.pushToAppendedViews(view)
        @$('#report').html(view.render().el)
    this


