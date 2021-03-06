import Widget from require "lapis.html"
list = require "static.lists.roleplay"

class RoleplayUniverse extends Widget
  content: =>
    -- title
    h1 @iiin "rp_universe_#{@universe}"
    -- create table
    element "table", ->
      thead ->
        tr ->
          th class: "table-col1", @iiin "rp_section"
          th class: "table-col2", @iiin "rp_resources"
      tbody ->
        -- get list of folders
        for pair in *list[@universe]
          section, links = pair[1], pair[2]
          tr ->
            td class: "table-col1", -> span @iiin "rp_section_#{section}"
            td class: "table-col2", ->
              for i=1,#links
                link = links[i]
                a href: "/rp/#{@universe}/#{section}/#{link}", @iiin "rp_link_#{link}"
                if i != #links
                  span " · "
    -- content
    div id: "content", -> raw @icontent
    