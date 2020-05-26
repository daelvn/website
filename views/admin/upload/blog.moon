import Widget from require "lapis.html"

class Login extends Widget
  content: =>
    div id: "upload-blog", ->
      h1 @iiin "admin_upload_blog"
      form action: "", method: "post", ->
        input    type: "hidden",   name: "csrf_token", value: @csrf_token
        input    type: "text",     name: "title",      placeholder: @iiin "admin_upload_blog_entry_name"
        textarea id:   "markdown", name: "entry"
        input    type: "submit",   name: "submit",     value: ">"
    -- simplemde
    link rel: "stylesheet", href: "/static/vendor/simplemde/dist/simplemde.min.css"
    script                   src: "/static/vendor/simplemde/dist/simplemde.min.js"
    script -> raw [[ var simplemde = new SimpleMDE({element: document.getElementById("markdown")}); ]]