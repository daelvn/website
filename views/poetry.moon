import Widget from require "lapis.html"

-- removes html suffix
basename = (f) -> f\match "(.+)%.html"

-- order of files and folders
order = require "static.lists.poems"

class Poetry extends Widget
  content: =>
    -- title
    h1 @iiin "p_index"
    -- description
    blockquote -> p -> raw @iiin "p_description"
    -- add sections
    for folder in *order.FOLDERS
      --ngx.log ngx.NOTICE, "generating category #{folder}"
      h2 @iiin "ps_#{folder}"
      -- add section descriptions
      blockquote -> p @iiin "pd_#{folder}"
      -- list all files and order them
      p ->
        for file in *order[folder]
          --ngx.log ngx.NOTICE, "generating index #{folder}/#{file}"
          ff = basename file
          a href: "/poetry/#{ff}", @iiin "pf_#{folder}_#{ff}"
          br!
    