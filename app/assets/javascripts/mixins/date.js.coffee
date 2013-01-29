class App.Mixins.Date

  parseRailsDate: (railsDate) ->
    date = railsDate.split('T')[0]
    time = railsDate.split('T')[1].split('Z')[0]
    return "#{date} #{time}"