class App.Mixins.Form
  flash: JST['layout/flash']

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
    $('#control_'+ attribute).addClass('error')
    $('#' + attribute).after("<span class=\"help-inline\">#{message}</span>")

  uniqueId: (length=8) ->
    id = ""
    id += Math.random().toString(36).substr(2) while id.length < length
    id.substr 0, length