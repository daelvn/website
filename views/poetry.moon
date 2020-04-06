import Widget from require "lapis.html"
fs               = require "filekit"

class Poetry extends Widget
  content: =>
    -- title
    h1 @iiin "p_index"
    -- description
    blockquote raw @iiin "p_description"
    -- add sections
    for folder in fs.ilist "poetry/en/"
      node = fs.combine "poetry/en/", folder
      continue if fs.isFile node
      h2 @iiin "ps_#{folder}"
      -- add section descriptions
      blockquote @iiin "pd_#{folder}"
      -- list all files and order them
      ordered = dofile fs.combine node, "order.lua"
      for file in *ordered[folder]
        a href: "/poetry/#{folder}/#{file}", @iiin "pf_#{folder}_#{file}"
      
    