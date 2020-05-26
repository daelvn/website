import Widget from require "lapis.html"

list = require "static.lists.roleplay"

class RoleplaySection extends Widget
  content: =>
    -- title
    h1 @iiin "rp_section_#{@section}"
    -- links
    for sct in *list[@universe]
      if sct[1] == @section
        links = sct[2]
        table.insert links, 1, "universe"
        for i=1,#links
          link = links[i]
          a href: "/rp/#{@universe}/#{@section}/#{link}", @iiin "rp_link_#{link}"
          if i != #links
            span " · "