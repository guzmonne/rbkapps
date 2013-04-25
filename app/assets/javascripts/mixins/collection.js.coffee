class App.Mixins.Collections
  getModelId: (targetModel, collection) ->
    for model, i in collection.models
      return i if model.id == targetModel.id

  colHasDupes: (array) ->
    sorted_array = array.sort()
    @results = []
    for element, i in sorted_array
      if sorted_array[i + 1] == sorted_array[i] then @results.push(sorted_array[i])
    return @results

