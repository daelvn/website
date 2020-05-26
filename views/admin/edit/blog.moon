import Widget from require "lapis.html"
import config from require "util.config"

class EditBlog extends Widget
  content: =>
    div id: "upload", ->
      h1 @iiin "admin_upload_blog"
      form action: "", method: "post", ->
        input type: "hidden", name: "csrf_token", value: @csrf_token
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
      script -> raw " var simplemde_#{lang} = new SimpleMDE({element: document.getElementById(\"markdown_#{lang}\")}); "
      --script -> raw " simplemde_#{lang}.value(); "
    script -> raw " var simplemde_uid = \"#{@uid}\"; "
    script                          src: "/static/vendor/httpget.js"
    script type: "application/lua", src: "/static/lua/simplemde-blog.lua"