import Widget from require "lapis.html"

class Roleplay extends Widget
  content: =>
    iframe src: "/empty"
    div id: "login", align: "center", ->
      h1 @iiin "login"
      form action: "", method: "post", ->
        input type: "password", name: "password"