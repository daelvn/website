import Widget from require "lapis.html"
import config from require "util.config"

class Login extends Widget
  content: =>
    div id: "upload-blog", ->
      h1 @iiin "admin_upload_blog"
      form action: "", method: "post", ->
        input type: "hidden", name: "csrf_token", value: @csrf_token
        h2 @iiin "admin_upload_blog_entry_codename"
        input type: "text", name: "title", placeholder: @iiin "admin_upload_blog_entry_codename"
        for lang in *config.dxvn.languages
          h2 @iiin "lang_#{lang}"
          h3 @iiin "admin_upload_blog_entry_content"
          textarea id: "markdown_#{lang}", name: "entry_#{lang}"
        h2 @iiin "submit"
        input type: "submit", name: "submit", value: ">"
    -- simplemde
    link rel: "stylesheet", href: "/static/vendor/simplemde/dist/simplemde.min.css"
    script                   src: "/static/vendor/simplemde/dist/simplemde.min.js"
    for lang in *config.dxvn.languages
      script -> raw " var simplemde = new SimpleMDE({element: document.getElementById(\"markdown_#{lang}\")}); "