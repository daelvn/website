-- is this really meant to be seen?
import Widget from require "lapis.html"

class Crawlspace extends Widget
  content: =>
    h1 "crawlspace."
    button onclick: "toast('aaaaaaa')", "do it."