html = require "lapis.html"
iiin = require "i18n"

class DefaultLayout extends html.Widget
  content: =>
    html_5 ->
      head ->
        link rel: "stylesheet", type: "text/css",  href: "/static/refine.css"
        link rel: "stylesheet", type: "text/css",  href: "/static/extra.css"
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
        script src: "/static/vendor/fengari-web.js", type: "text/javascript"
        -- scripts
        script src: "https://kit.fontawesome.com/5a83bed402.js", crossorigin: "anonymous"
        script src: "/static/lua/scroll.lua",   type: "application/lua"
        script src: "/static/lua/lastpage.lua", type: "application/lua"
      body id: "write", ->
        -- back button
        div id: "lastpage-container", ->
          -- Last page button
          -- button id: "lastpage", onclick: "window.history.go(-1); return false;", title: "Go back", -> i class: "fas fa-arrow-left"
        -- language selection
        div style: "float: right;", ->
          form action: "", method: "post", ->
            button class: "link", name: "lang", value: "en", "english"
            span "·"
            button class: "link", name: "lang", value: "es", "español"
        -- content
        @content_for "inner"
        -- scroll to top button
        button id: "scrollback", title: "Go up", -> i class: "fas fa-arrow-up"
        -- attribution
        --blockquote -> raw @footer
        -- social media
        hr class: "footer-hr"
        footer id: "footer", ->
          span ->
            a class: "footer-link", href: "/sn/github",    -> i class: "fab fa-github"
            a class: "footer-link", href: "/sn/spotify",   -> i class: "fab fa-spotify"
            a class: "footer-link", href: "/sn/discord",   -> i class: "fab fa-discord"
            a class: "footer-link", href: "/sn/instagram", -> i class: "fab fa-instagram"
            a class: "footer-link", href: "/sn/pinterest", -> i class: "fab fa-pinterest"
            a class: "footer-link", href: "/sn/mail",      -> i class: "far fa-envelope"
            br!
            --span style: "font-size: 11px;", -> raw "made by dael. powered by <a href='https://leafo.net/lapis'>lapis</a> by @leafo. kindly hosted by <a href='https://ahti.space'>ahti.space</a>."
            span style: "font-size: 11px;", -> raw @iiin "footer"