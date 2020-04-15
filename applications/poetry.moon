import cached from require "lapis.cache"
lapis            = require "lapis"
iiin             = require "i18n"

-- function to find the folder for a file
order    = require "static.lists.poems"
findPoem = (file) ->
  for categ, t in pairs order
    for fl in *t
      return categ if "#{file}.html" == fl
  return false

-- reads the contents of an html file
readfile = (file) ->
  --ngx.log ngx.NOTICE, "opening #{file.html} to display"
  local contents
  with io.open "#{file}.html", "r"
    contents = \read "*a"
    \close!
  return contents

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
    -- check access
    @session.access or= "key:basic"
    checkAccess = require "util.access"
    levels      = require "static.lists.access"
    unless checkAccess "poetry", levels[@session.access]
      return @write redirect_to: "/login?redirect=#{@req.parsed_url.path}"
  --# routes #--
  -- /poetry
  "/poetry": =>
    @title       = iiin "p_title"
    @description = iiin "p_description"
    @footer      = iiin "footer"
    render: "poetry"
  -- /poetry/:file
  "/poetry/:file": cached =>
    category = findPoem @params.file
    return status: 404 unless category
    --
    @title       = (iiin "pf_#{category}_#{@params.file}") .. "."
    @description = iiin "p_description"
    @footer      = iiin "footer"
    content      = readfile "page/poetry/#{@session.locale}/#{category}/#{@params.file}"
    return content
  -- /poetry/raw/:file
  "/poetry/raw/:file": =>
    layout: false, readfile "page/poetry/raw/#{@session.locale}/#{@params.file}"