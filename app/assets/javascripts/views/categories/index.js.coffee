class App.Views.CategoriesIndex extends Backbone.View
  template: JST['categories/index']
  className: 'span12'
  name: 'CategoriesIndex'

  events:
    'click #fetch-categories'         : 'fetchCategories'
    'keydown :input'                  : 'keyDownManager'
    'mouseover td'                    : 'showDeleteButton'
    'mouseout td'                     : 'removeDeleteButton'
    'click .delete_category'          : 'deleteCategory'
    'click .add_category'             : 'createCategory'

  initialize: ->
    @fh = new App.Mixins.Form()
    @pivotCollection = new App.Collections.Categories()

  render: ->
    $(@el).html(@template())
    this

  keyDownManager: (e) ->
    switch e.keyCode
      when 9 # Tab
        switch e.currentTarget.id
          when "category1"
            e.preventDefault()
            @$('#category2').focus()
            break
          when "category2"
            e.preventDefault()
            @$('#category3').focus()
            break
          when "category3"
            e.preventDefault()
            @$('#category3').val('')
            break
        break
      when 13 # Enter
        switch e.currentTarget.id
          when "category1", "category2", "category3"
            e.preventDefault()
            @createCategory()
            break
    this

  deleteCategory: (e) ->
    e.preventDefault()
    result = confirm("Esta seguro que desea eliminar esta categoría?")
    return unless result
    a       = e.target.offsetParent.className.split(' ')
    id      = e.target.dataset['id']
    level   = a.length - 2
    @models  = []
    if id == undefined then id = e.currentTarget.dataset['id']
    model = App.categories.get(id)
    if level == 1
      @models = App.categories.where({category1: model.get('category1')})
    if level == 2
      @models = App.categories.where({category1: model.get('category1'), category2: model.get('category2')})
    if level == 3
      @models = App.categories.where({category1: model.get('category1'), category2: model.get('category2'), category3: model.get('category3')})
    for m, i in @models
      App.categories.remove(m)
      if (i + 1) == @models.length
        @prepareAndAppendCategories()
    model.destroy(level)


  createCategory: (e) ->
    e.preventDefault() if e?
    category1 = @$('#category1').val()
    category2 = @$('#category2').val()
    category3 = @$('#category3').val()
    if App.categories.length == 0
      App.categories.fetch success: =>
        return unless @validates(category1, category2, category3)
    else return unless @validates(category1, category2, category3)
    if category2 == '' then category2 = 'SSC'
    if category3 == '' then category3 = 'STC'
    model = new App.Models.Category()
    model.save {category1: category1, category2: category2, category3: category3}, success: =>
      @$('#categories').empty()
      @fh.displayFlash('success', "La categoría se ha creado con exito")
      if category2 == ''
        @$('#category2').focus()
      else
        @$('#category3').val('')
        @$('#category3').focus()
      App.categories.add(model)
      @prepareAndAppendCategories()

  validates: (c1, c2, c3) ->
    @$('#notice').empty()
    if c1 == ''
      @fh.displayFlash("error","El campo 'Categoría' no puede quedar vacío")
      return false
    if c2 == '' and c3 != ''
      @fh.displayFlash("error", "El campo 'Sub-Categoría' no puede quedar vacío si se quiere agregar una 'Tercer Categoría'")
      return false
    c3s = App.categories.pluckDistinct('category3', {category1: c1, category2: c2})
    if c3s.indexOf(c3) > -1
      @fh.displayFlash("error" ,"Ya existe la Tercer Categoría")
      return false
    c2s = App.categories.pluckDistinct('category2', {category1: c1})
    if c2s.indexOf(c2) > -1 and c3 == ''
      @fh.displayFlash("error","Ya existe la Sub-Categoría")
      return false
    c1s = App.categories.pluck('category1')
    if c1s.indexOf(c1) > -1 and c2 == '' and c2 == ''
      @fh.displayFlash("error","Ya existe la Categoría")
      return false
    return true

  fetchCategories: (e) ->
    e.preventDefault() if e?
    App.vent.trigger 'update:categories:success'
    @$('#fetch-categories').html('<i class="icon-load"></i>  Actualizando').addClass('loading')
    App.categories.fetch success: =>
      @$('#fetch-categories').html('Actualizar').removeClass('loading')
      @prepareAndAppendCategories()
    this

  prepareAndAppendCategories: ->
    @$('#categories').empty()
    @count = @cat1 = @cat2 = @cat3 = 0
    @lastCategory = App.categories.models[0].get('category1')
    @lastSubcategory = App.categories.models[0].get('category2')
    App.categories.each(@appendCategory)

  appendCategory: (model) =>
    if @lastCategory != model.get('category1')
      @rowCategory(@pivotCollection)
      @pivotCollection = new App.Collections.Categories()
      @pivotCollection.add(model)
      @lastCategory = model.get('category1')
    else
      @pivotCollection.add(model)
      @lastCategory = model.get('category1')
    @count = @count + 1
    if @count == App.categories.length
      @rowCategory(@pivotCollection)
      @pivotCollection = new App.Collections.Categories()
    this

  rowCategory: (collection) =>
    collection.sortVar = 'category2'
    collection.sort()
    @lcat = collection.length
    subcategories = collection.pluckDistinct('category2')
    for subcategory, i in subcategories
      @subs = collection.where({category2: subcategory})
      for sub, j in @subs
        deleteButton = "<button class='btn btn-mini btn-danger hide pull-right delete_category' data-id='#{sub.id}'><i class='icon-remove icon-white'></i></button><button class='btn btn-mini btn-warning hide pull-right edit_category' data-id='#{sub.id}' style='margin-right: 3px;'><i class='icon-pencil icon-white'></i></button>"
        if i == 0 and j == 0
          @$('#categories').append("<tr><td class='cat#{@cat1%2} #{sub.get('category1').replace(' ', '_')}' rowspan='#{@lcat}'>#{sub.get('category1')}#{deleteButton}</td><td class='cat#{@cat2%2} #{sub.get('category1').split(' ').join('_')} #{sub.get('category2').split(' ').join('_')}' rowspan='#{@subs.length}'>#{sub.get('category2')}#{deleteButton}</td><td class='cat#{@cat3%2} #{sub.get('category1').split(' ').join('_')} #{sub.get('category2').split(' ').join('_')} #{sub.get('category3').split(' ').join('_')}'>#{sub.get('category3')}#{deleteButton}</td></tr>")
          @cat1 = @cat1 + 1
          @cat2 = @cat2 + 1
          @cat3 = @cat3 + 1
        else
          if j == 0
            @$('#categories').append("<tr><td class='cat#{@cat2%2} #{sub.get('category1').replace(' ', '_')} #{sub.get('category2').split(' ').join('_')}' rowspan='#{@subs.length}'>#{sub.get('category2')}#{deleteButton}</td><td class='cat#{@cat3%2} #{sub.get('category1').split(' ').join('_')} #{sub.get('category2').split(' ').join('_')} #{sub.get('category3').split(' ').join('_')}'>#{sub.get('category3')}#{deleteButton}</td></tr>")
            @cat2 = @cat2 + 1
            @cat3 = @cat3 + 1
          else
            @$('#categories').append("<tr><td class='cat#{@cat3%2} #{sub.get('category1').replace(' ', '_')} #{sub.get('category2').split(' ').join('_')} #{sub.get('category3').split(' ').join('_')}'>#{sub.get('category3')}#{deleteButton}</td></tr>")
            @cat3 = @cat3 + 1
      @$('td:empty').text('***')

  showDeleteButton: (e) ->
    e.preventDefault() if e?
    @$('.btn-danger').hide()
    $('button', e.currentTarget).show()
    @selectRow(e)

  removeDeleteButton: (e) ->
    e.preventDefault() if e?
    $('button', e.currentTarget).hide()
    @$('td').removeClass('selected_td')

  selectRow: (e) ->
    @$('.selected_td').removeClass('selected_td')
    array = e.currentTarget.className.split(" ")
    switch array.length
      when 2
        targetClass = array[1]
        $(".#{targetClass}", e.currentTarget.offsetParent).addClass('selected_td')
        break
      when 3
        targetClass1 = array[1]
        targetClass2 = array[2]
        $(".#{targetClass1}.#{targetClass2}", e.currentTarget.offsetParent).addClass('selected_td')
        break
      when 4
        targetClass1 = array[1]
        targetClass2 = array[2]
        targetClass3 = array[3]
        $(".#{targetClass1}.#{targetClass2}.#{targetClass3}", e.currentTarget.offsetParent).addClass('selected_td')
        break
