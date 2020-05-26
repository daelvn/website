import Widget from require "lapis.html"
import all    from require "controllers.blog"

class Blog extends Widget
  content: =>
    -- title
    h1 @iiin "b_index"
    -- description
    blockquote -> p -> raw @iiin "b_description"
    -- create table
    element "table", ->
      thead ->
        tr ->
          th class: "table-col1", @iiin "b_date"
          th class: "table-col2", @iiin "b_entry"
      tbody ->
        -- render
        for entry in *all!
          tr ->
            td class: "table-col1", -> span entry.created_at
            td class: "table-col2", -> a href: "/blog/#{entry.uid}", entry.name
          