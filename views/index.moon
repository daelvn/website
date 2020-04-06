import Widget from require "lapis.html"
inspect = require "inspect"

class Index extends Widget
  content: =>
    h1 ->
      a name: "index"
      @iiin "index"
    