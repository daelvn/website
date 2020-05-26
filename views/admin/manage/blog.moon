import Widget from require "lapis.html"
import config from require "util.config"
import all    from require "controllers.blog"

class ManageBlog extends Widget
  content: =>
    div id: "manage", ->
      h1 @iiin "admin_manage_blog"
      form action: "", method: "post", ->
        input type: "hidden", name: "csrf_token", value: @csrf_token
        element "table", ->
          thead ->
            tr ->
              th @iiin "admin_manage_blog_name"
              th @iiin "admin_manage_blog_actions"
              for lang in *config.dxvn.languages
                th @iiin "admin_manage_blog_title_#{lang}"
          tbody ->
            entryl = all!
            if "table" == typeof entryl
              for entry in *all!
                tr ->
                  td -> span entry.name
                  td ->
                    button type: "submit", name: "view",   value: entry.uid, @iiin "admin_manage_blog_view"
                    button type: "submit", name: "delete", value: entry.uid, @iiin "admin_manage_blog_delete"
                    button type: "submit", name: "edit",   value: entry.uid, @iiin "admin_manage_blog_edit"
                    button type: "submit", name: "change", value: entry.uid, @iiin "admin_manage_blog_change"
                  for lang in *config.dxvn.languages
                    td -> input type: "text", name: "title_#{entry.name}_#{lang}", value: entry["title_#{lang}"]