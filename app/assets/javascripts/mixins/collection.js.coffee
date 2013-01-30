class App.Mixins.Collections
  getModelId: (targetModel, collection) ->
    for model, i in collection.models
      return i if model.id == targetModel.id