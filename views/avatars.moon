import Widget from require "lapis.html"
fs               = require "filekit"

-- count
getn = (t) ->
  n = 0
  for _, _ in pairs t do n += 1
  n

-- split table into four
split4 = (t) ->
  a, b, c, d = {}, {}, {}, {}
  n          = 1
  for k, v in pairs t
    switch n
      when 1 then a[k] = v
      when 2 then b[k] = v
      when 3 then c[k] = v
      when 4 then d[k] = v
      when 5
        a[k] = v
        n    = 1
    n += 1
  return a, b, c, d

-- get list of avatars
avatars = require "static.lists.avatars"

class Avatars extends Widget
  content: =>
    div class: "gallery-row", ->
      aa, bb, cc, dd = split4 avatars
      cols           = {aa, bb, cc, dd}
      for col in *cols
        div class: "gallery-column", ->
          for file, source in pairs col
            if text = source\match "popup: (.+)"
              a href: "#", onclick: "window.alert('#{text}')", ->
                img src:"static/img/avatar/#{file}"
            else
              a href: source, ->
                img src: "static/img/avatar/#{file}"


