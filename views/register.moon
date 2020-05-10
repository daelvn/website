import Widget from require "lapis.html"

class Register extends Widget
  content: =>
    iframe src: "/empty"
    div id: "login", align: "center", ->
      h1 @iiin "register"
      form action: "", method: "post", ->
        input type: "hidden",   name: "csrf_token", value: @csrf_token
        input type: "text",     name: "username",   placeholder: "Username"
        input type: "password", name: "password",   placeholder: "Password"
        input type: "submit",   name: "submit",     value: ">"