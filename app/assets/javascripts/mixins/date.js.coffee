class App.Mixins.DateHelper

  parseRailsDate: (railsDate) ->
    return if railsDate == undefined
    date = railsDate.split('T')[0]
    time = railsDate.split('T')[1].split('Z')[0]
    return "#{date} #{time}"

  dateRailsOnly: (railsDate) ->
    return @parseRailsDate(railsDate).split(' ')[0]

  dateDiff: (date1, date2) ->
    date1 = @dateToDate(date1)
    date2 = @dateToDate(date2)
    d = Math.abs(date1 - date2)
    return Math.floor(d / (24 * 60 * 60 * 1000))

  dateSmallerThan: (date1, date2) ->
    date1 = @dateToDate(date1)
    date2 = @dateToDate(date2)
    d = Math.floor((date1 - date2) / (24 * 60 * 60 * 1000))
    if d <= 0 then return true else return false

  dateBusDiff: (date1, date2) ->
    date1 = @dateToDate(date1)
    date2 = @dateToDate(date2)
    iWeeks = iDateDiff = iAdjust = 0
    if date2 < date1 then return -1
    iWeekday1 = date1.getDay()
    iWeekday2 = date2.getDay()
    if iWeekday1 == 0 then iWeekday1 = 7
    if iWeekday2 == 0 then iWeekday2 = 7
    if (iWeekday1 > 5) and (iWeekday2 > 5) then iAdjust = 1
    iOriginalWeekday1 = iWeekday1
    iOriginalWeekday2 = iWeekday2
    if iWeekday1 > 5 then iWeekday1 = 5
    if iWeekday2 > 5 then iWeekday2 = 5
    sub =  ( date2.getTime() - date1.getTime() )
    iWeeks = Math.floor( sub/604800000)
    if (iOriginalWeekday1 <= iOriginalWeekday2)
      iDateDiff = (iWeeks * 5) + (iWeekday2 - iWeekday1)
    else
      iDateDiff = ((iWeeks + 1) * 5) - (iWeekday1 - iWeekday2)
    iDateDiff -= iAdjust
    return (iDateDiff + 1)

  dateToDate: (date) ->
    if date == null then return -1
    if date.split('T').length > 1 then date = @dateRailsOnly(date)
    d = date.split('-')
    t = new Date.parse("#{d[0]}-#{d[2]}-#{d[1]}")
    return t

  now: ->
    d = new Date()
    year = d.getFullYear()
    month = d.getMonth() + 1
    day = d.getDate()
    if month < 10 then month = "0#{month}"
    return "#{year}-#{month}-#{day}"
