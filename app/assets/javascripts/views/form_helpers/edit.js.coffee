class App.Views.FormHelperEdit extends Backbone.View
  template: JST['form_helpers/edit']
  name: 'FormHelperEdit'
  className: 'span12'

  events:
    'click li.dropdown-submenu ul li a'   : 'selectField'
    'keydown #field_name'                 : 'noTyping'
    'keyup #field_name'                   : 'noTyping'
    'click #add-form_helper'              : 'addFormHelper'
    'keydown #new-form_helper'            : 'keyDownManager'
    'click ul#form_helpers li a'            : 'removeHelper'

  initialize: ->
    @collection = new App.Collections.FormHelpers()
    @formHelperField = ""

  render: ->
    $(@el).html(@template())
    this

  selectField: (e) ->
    @array = []
    @formHelperField = e.currentTarget.dataset["form_helper"]
    @$('#field_name').val($(e.target).text())
    @$('#values').show()
    @$('#form_helpers').empty()
    @array = App.formHelpers.where({column: @formHelperField})
    for fh in @array
      @$('#form_helpers').append("<li><a data-id='#{fh.id}'><i class='icon-remove-circle' data-id='#{fh.id}'></i> #{fh.get('value')}</a></li>")

  noTyping: (e) ->
    e.preventDefault()

  addFormHelper: (e) ->
    e.preventDefault() if e?
    value = @$("#new-form_helper").val()
    if @array.indexOf(value) > -1 or value == "" then return
    attributes =
      column: @formHelperField
      value : @$("#new-form_helper").val()
    model = new App.Models.FormHelper
    model.save attributes, success: =>
      App.formHelpers.add(model)
      @$('#form_helpers').append("<li><a data-id='#{model.id}'><i class='icon-remove-circle'></i> #{model.get('value')}</a></li>")
      @$("#new-form_helper").val('').focus()

  keyDownManager: (e) ->
    if e.keyCode == 13 then @addFormHelper()

  removeHelper: (e) ->
    e.preventDefault()
    result = confirm("Esta seguro que desea eliminar este valor")
    if result
      id = e.currentTarget.dataset["id"]
      model = App.formHelpers.get(id)
      model.destroy()
      @$("a[data-id=#{id}]").parent().remove()


