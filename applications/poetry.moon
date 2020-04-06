lapis = require "lapis"
iiin  = require "i18n"

-- function to find the folder for a file
order    = require "poetry.order"
findPoem = (file) ->
  for categ, t in pairs order
    for fl in *t
      return categ if "#{file}.html" == fl
  return false  

class Poetry extends lapis.Application
  -- layout
  layout: require "views.layout"
  -- before
  @before_filter =>
    -- helper functions
    @iiin = (...) => iiin ...
    -- set locale
    @session.locale = @params.lang or @session.locale or "en"
    iiin.loadFile "i18n/#{@session.locale}.lua"
    iiin.setLocale @session.locale
  --# routes #--
  -- /poetry
  "/poetry": =>
    @title       = iiin "p_title"
    @description = iiin "p_description"
    @footer      = iiin "footer"
    render: "poetry"
  -- /poetry/:file
  "/poetry/:file": =>
    category = findPoem @params.file
    return status: 404 unless category
    --
    layout: false, require "poetry.#{@session.locale}.#{category}.#{@params.file}"