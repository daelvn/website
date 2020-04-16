lapis = require "lapis"
iiin  = require "i18n"
fs    = require "filekit"

-- renders a number as two digits
twodigit = (n) -> return string.format "%02d", tonumber n

-- reads the contents of an html file
readfile = (file) ->
  --ngx.log ngx.NOTICE, "opening #{file.html} to display"
  local contents
  with io.open "#{file}", "r"
    contents = \read "*a"
    \close!
  return contents

class Blog extends lapis.Application
  -- layout
  layout: require "views.layout"
  -- before
  @before_filter =>
    -- iframe header
    @res.headers["X-Frame-Options"] = "SAMEORIGIN"
    -- helper functions
    @iiin = (...) => iiin ...
    -- set locale
    @session.locale = @params.lang or @session.locale or "en"
    iiin.loadFile "i18n/#{@session.locale}.lua"
    iiin.setLocale @session.locale
    -- check permissions
    @session.access or= "key:basic"
    checkAccess = require "util.access"
    levels      = require "static.lists.access"
    unless checkAccess "blog", levels[@session.access]
      return @write redirect_to: "/login?redirect=#{@req.parsed_url.path}"
  --# routes #--
  "/blog": =>
    @title       = iiin "b_title"
    @description = iiin "b_description"
    render: "blog"
  "/blog/:yyyy/:mm/:name": =>
    file         = (fs.glob "page/blog/#{@session.locale}/*.#{twodigit @params.mm}.#{@params.yyyy}-#{@params.name}.html")[1]
    @title       = iiin "be_#{@params.name}"
    @description = iiin "b_description"
    content      = readfile file
    return content
  "/blog/raw/:file": =>
    layout: false, readfile "page/blog/#{@session.locale}/raw/#{@params.file}"
  "/blog/*": => redirect_to: "/blog"