class App.Mixins.Date

  parseRailsDate: (railsDate) ->
    return if railsDate == undefined
    date = railsDate.split('T')[0]
    time = railsDate.split('T')[1].split('Z')[0]
    return "#{date} #{time}"

  dateRailsOnly: (railsDate) ->
    return @parseRailsDate(railsDate).split(' ')[0]