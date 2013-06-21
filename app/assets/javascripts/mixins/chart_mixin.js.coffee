class App.Mixins.ChartHelper

  COLORS: [
    [253,52,2]
    [207,2,2]
    [90,2,2]
    [2,158,2]
    [29,2,54]
    [4,2,253]
    [143,2,84]
    [253,136,2]
    [2,49,2]
    [249,2,2]
    [2,81,94]
    [253,155,2]
    [2,55,253]
    [2,131,40]
    [7,2,94]
    [253,2,141]
    [253,2,78]
    [2,26,54]
    [253,127,2]
    [253,103,2]
    [2,52,113]
    [164,2,64]
    [2,123,125]
  ]

  diffColor: (c, colors, index) ->
    return c if colors.length == 1
    while (colors.indexOf(c) > -1 and c > 150 )
      c = @goldenHSVtoRGB()[index]
    return c

  hsvToRGB: (h, s, v) ->
    h_i = parseInt(h*6)
    f = h*6 - h_i
    p = v * (1 - s)
    q = v * (1 - f*s)
    t = v * (1 - (1 - f) * s )
    if h_i == 0
      r = v; g = t; b = p
    if h_i == 1
      r = q; g = p; b = v
    if h_i == 2
      r = p; g = v; b = t
    if h_i == 3
      r = p; g = q; b = v
    if h_i == 4
      r = t; g = p; b = v
    if h_i == 5
      r = v; g = p; b = q
    return [parseInt(r*256), parseInt(g*256), parseInt(b*256)]

  goldenHSVtoRGB: ->
    golden_ratio_conjugate = 0.618033988749895
    h = @alea(256)
    h += golden_ratio_conjugate
    h %= 1
    @hsvToRGB(h, 0.6, 0.6)

  alea: (max) ->
    return Math.random() * max

  randomColor: ->
    return @COLORS[parseInt(@alea(@COLORS.length))]

  randomRGB: ->
    return [parseInt(@alea(256)), parseInt(@alea(256)), parseInt(@alea(256))]