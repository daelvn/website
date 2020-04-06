html = require "lapis.html"
iiin = require "i18n"

class DefaultLayout extends html.Widget
  content: =>
    html_5 ->
      head ->
        link rel: "stylesheet", type: "text/css",  href: "/static/refine.css"
        link rel: "icon",       type: "image/png", href: "/static/favicon-32.png"
        title @title or "dael's blog."
        -- other meta
        meta charset: "UTF-8"
        meta name: "description", content: @description
        meta name: "keywords",    content: "dael, poetry, art, blog, portfolio"
        meta name: "author",      content: "Dael Muñiz"
        -- opengraph
        meta property: "og:type",        content: "website"
        meta property: "og:title",       content: @title
        meta property: "og:description", content: @description
        meta property: "og:url",         content: "https://daelvn.com"
        meta property: "og:image",       content: @thumbnail
        -- fengari
        -- script src: "/static/vendor/fengari-web.js", type: "text/javascript"
        -- scripts
        --script src: "/static/lua/locale.lua", type: "application/lua"
      body id: "write", ->
        -- language selection
        div style: "float: right;", ->
          form action: "", method: "post", ->
            button class: "link", name: "lang", value: "en", "english"
            span "·"
            button class: "link", name: "lang", value: "es", "español"
        -- content
        @content_for "inner"
        -- attribution
        blockquote -> raw @footer