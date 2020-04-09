import Widget from require "lapis.html"
sections         = require "static.lists.sections"

class Index extends Widget
  content: =>
    h1 @iiin "index"
    blockquote -> p @iiin "intro"
    h2 @iiin "links"
    for section in *sections
      h3 -> a href: "/#{section}", @iiin "sen_#{section}"
      blockquote -> p @iiin "sed_#{section}"