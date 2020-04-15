lapis   = require "lapis"
iiin    = require "i18n"
fs      = require "filekit"

charExists = (ch) -> fs.isDir "page/rp/#{ch}/"

-- reads the contents of an html file
readfile = (file) ->
  --ngx.log ngx.NOTICE, "opening #{file.html} to display"
  local contents
  with io.open "#{file}", "r"
    contents = \read "*a"
    \close!
  return contents

class Roleplay extends lapis.Application
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
    unless checkAccess "roleplay", levels[@session.access]
      return @write redirect_to: "/login?redirect=#{@req.parsed_url.path}"
  --# routes #--
  -- /rp
  "/rp": =>
    @title       = iiin "rp_title"
    @description = iiin "rp_description"
    @footer      = iiin "footer"
    render: "roleplay.roleplay"
  -- /rp/:universe
  "/rp/:universe": =>
    return render: "404", status: 404 unless fs.exists "page/rp/#{@params.universe}.html"
    @title       = iiin "rp_chart_#{@params.char}"
    @description = iiin "rp_chard_#{@params.char}"
    @footer      = iiin "footer"
    @universe    = @params.universe
    @content     = readfile "page/rp/#{@params.universe}.html"
    render: "roleplay.universe"
  -- /rp/:universe/:section
  "/rp/:universe/:section": =>
    return render: "404", status: 404 unless charExists @params.section
    @title       = iiin "rp_chart_#{@params.section}"
    @description = iiin "rp_chard_#{@params.section}"
    @footer      = iiin "footer"
    @universe    = @params.universe
    @section     = @params.section
    render: "roleplay.section"
  -- /rp/:universe/:section/universe -> /rp/:universe
  "/rp/:universe/:section/universe": =>
    redirect_to: "/rp/#{@params.universe}"
  -- /rp/:universe/:section/:page
  "/rp/:universe/:section/:page": =>
    return render: "404", status: 404 unless charExists @params.section
    @title       = iiin "rp_chart_#{@params.section}"
    @description = iiin "rp_chard_#{@params.section}"
    @footer      = iiin "footer"
    @universe    = @params.universe
    @section     = @params.section
    content      = readfile "page/rp/#{@params.section}/#{@params.page}.html"
    return content