import Widget from require "lapis.html"
import config from require "util.config"
import all    from require "controllers.categories"

class UploadPoetry extends Widget
  content: =>
    div id: "upload", ->
      h1 @iiin "admin_upload_poetry"
      form action: "", method: "post", ->
        -- CSRF token
        input type: "hidden", name: "csrf_token", value: @csrf_token
        -- codename
        h2 @iiin "admin_upload_poetry_entry_codename"
        input type: "text", name: "title", placeholder: @iiin "admin_upload_blog_entry_codename"
        -- category
        h2 @iiin "admin_upload_poetry_entry_category"
        select name: "category", ->
          for cat in *all!
            option value: cat, cat
        -- order
        h2 @iiin "admin_upload_poetry_entry_order"
        input type: "number", name: "order", min: "1", placeholder: "1"
        -- textboxes
        for lang in *config.dxvn.languages
          h2 @iiin "lang_#{lang}"
          -- title
          h3 @iiin "admin_upload_poetry_entry_title"
          input type: "text", name: "title_#{lang}", placeholder: @iiin "admin_upload_poetry_entry_title"
          -- content
          h3 @iiin "admin_upload_blog_poetry_content"
          textarea id: "markdown_#{lang}", name: "entry_#{lang}"
        -- submit
        h2 @iiin "submit"
        input type: "submit", name: "submit", value: ">"
    -- simplemde
    link rel: "stylesheet", href: "/static/vendor/simplemde/dist/simplemde.min.css"
    script                   src: "/static/vendor/simplemde/dist/simplemde.min.js"
    for lang in *config.dxvn.languages
      script -> raw " var simplemde = new SimpleMDE({element: document.getElementById(\"markdown_#{lang}\")}); "