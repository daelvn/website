import Widget from require "lapis.html"

class Login extends Widget
  content: =>
    iframe src: "/empty"
    div id: "login", align: "center", ->
      h1 @iiin "login"
      form action: "", method: "post", ->
        input type: "hidden",   name: "csrf_token", value: @csrf_token
        input type: "text",     name: "username",   placeholder: @iiin "username"
        input type: "password", name: "password",   placeholder: @iiin "password"
        input type: "submit",   name: "submit",     value: ">"