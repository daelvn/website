import Widget from require "lapis.html"

-- order of files and folders
order = require "gallery.order"

class Gallery extends Widget
  content: =>
    -- title
    h1 @iiin "g_index"
    -- description
    blockquote -> p -> raw @iiin "g_description"