class App.Mixins.Form
  flash: JST['layout/flash']
  listFlash: JST['layout/list_flash']

  cleanForm: (formId) ->
    $(formId)[0].reset()
    @removeValidations()

  removeValidations: ->
    if $('.control-group').hasClass('error') then $('.control-group').removeClass('error')
    $('form span').remove()

  displayFlash: (type, message, time=3000, display=true) ->
    flashId = @uniqueId()
    $('#notice').append( @flash(type: type, message: message, id: flashId)) if display = true
    setTimeout( ->
      $('#' + flashId).fadeOut('slow', -> $('#' + flashId).remove())
    , time)
    return @flash(type: type, message: message, id: flashId)

  showInForm: (attribute, message) ->
    $('#control-'+ attribute).addClass('error')
    $('#' + attribute).after("<span class=\"help-inline\">#{message}</span>")

  uniqueId: (length=8) ->
    id = ""
    id += Math.random().toString(36).substr(2) while id.length < length
    id.substr 0, length

  forEachPrint: (array, begin, end) ->
    for element in array
      "#{begin} #{element} #{end}"

  modalToSelect: (modal, attribute, destination) =>
    $(modal).modal('toggle')
    $(modal).on('shown', => $(attribute).focus() )
    newAttribute = $(attribute).val()
    if newAttribute == "" then return @
    $(attribute).val('')
    $(destination).append("<option>#{newAttribute}</option>")
    $(destination).select2("val", "#{newAttribute}")
    this

  correctDecimal: (decimal) ->
    if decimal == null or "" then return "0.00"
    if decimal.split('.')[1] == undefined then return "#{decimal}.00"
    i = decimal.split('.')[1].length - 2
    if i == 0 then return decimal
    if i == -1
      return "#{decimal}0"
    if i > 0
      return decimal.substring(0, decimal.length - i)
    this

  addDays: (myDate,days) ->
    date = new Date(myDate.getTime() + days * 24 * 60 * 60 * 1000);
    return "#{date.getFullYear()}-#{date.getMonth() + 1}-#{date.getDate()}"

  displayListFlash: (type, messages, time=3000) ->
    flashId = @uniqueId()
    if time == 0
      $('#notice').append( @listFlash(type: type, messages: messages, id: flashId) )
    else
      $('#notice').append( @listFlash(type: type, messages: messages, id: flashId) )
      setTimeout( ->
        $('#' + flashId).fadeOut('slow', -> $('#' + flashId).remove())
      , time)
      return #@flash(type: type, message: message, id: flashId)
