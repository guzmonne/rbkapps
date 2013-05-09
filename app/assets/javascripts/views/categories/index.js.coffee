class App.Views.CategoriesIndex extends Backbone.View
  template: JST['categories/index']
  className: 'span12'
  name: 'CategoriesIndex'

  events:
    'click #fetch-categories'         : 'fetchCategories'
    'keydown :input'                  : 'keyDownManager'

  initialize: ->
    @fh = new App.Mixins.Form()
    @pivotCollection = new App.Collections.Categories()
    @cat1 = 0
    @cat2 = 0
    @cat3 = 0

  render: ->
    $(@el).html(@template())
    this

  keyDownManager: (e) ->
    switch e.keyCode
      when 9 # Tab
        switch e.currentTarget.id
          when "category1"
            @$('#category2').focus()
            break
          when "category2"
            @$('#category3').focus()
            break
          when "category3"
            @$('#category3').val('')
            break
        break
      when 13 # Enter
        switch e.currentTarget.id
          when "category1", "category2", "category3"
            @createCategory()
            break
    this

  createCategory: (e) ->
    category1 = @$('#category1').val()
    category2 = @$('#category2').val()
    category3 = @$('#category3').val()
    model = new App.Models.Category()
    model.save {category1: category1, category2: category2, category3: category3}, success: =>
      @fh.displayFlash('success', "La categoría se ha creado con exito")
      @$('#category3').val('')
      App.categories.add(model)
      @$('#categories').html('')
      App.categories.each(@appendCategory())

  fetchCategories: (e) ->
    e.preventDefault()
    @count = 0
    @$('#categories').html('')
    App.vent.trigger 'update:categories:success'
    @$('#fetch-categories').html('<i class="icon-load"></i>  Actualizando').addClass('loading')
    App.categories.fetch success: =>
      @$('#fetch-categories').html('Actualizar').removeClass('loading')
      @lastCategory = App.categories.models[0].get('category1')
      @lastSubcategory = App.categories.models[0].get('category2')
      App.categories.each(@appendCategory)
    this

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
        if i == 0 and j == 0
          @$('#categories').append("<tr><td class='cat#{@cat1%2}' rowspan='#{@lcat}'>#{sub.get('category1')}</td><td class='cat#{@cat1%2}' rowspan='#{@subs.length}'>#{sub.get('category2')}</td><td class='cat#{@cat1%2}'>#{sub.get('category3')}</td></tr>")
        else
          if j == 0
            @$('#categories').append("<tr><td class='cat#{@cat2%2}' rowspan='#{@subs.length}'>#{sub.get('category2')}</td><td class='cat#{@cat2%2}'>#{sub.get('category3')}</td></tr>")
          else
            @$('#categories').append("<tr class='cat#{@cat3%2}'><td>#{sub.get('category3')}</td></tr>")
      @cat1 = @cat1 + 1
      @cat2 = @cat2 + 1
      @cat3 = @cat3 + 1
      @$('td:empty').text('***')