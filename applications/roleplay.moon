lapis   = require "lapis"
iiin    = require "i18n"

charExists = (ch) -> fs.exists "rp/#{ch}/"

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
  --# routes #--
  -- /rp
  "/rp": =>
    @title       = iiin "rp_title"
    @description = iiin "rp_description"
    @footer      = iiin "footer"
    render: "roleplay"
  -- /rp/:char
  "/rp/:char": =>
    return status: 404 unless charExists @params.char
    @title       = iiin "rp_chart_#{@params.char}"
    @description = iiin "rp_chard_#{@params.char}"
    @footer      = iiin "footer"
    @character   = @params.char
    render: "character"
  -- /rp/:char/bio
  "/rp/:char/bio": =>
    return status: 404 unless charExists @params.char
    @title       = iiin "rp_chart_#{@params.char}"
    @description = iiin "rp_chard_#{@params.char}"
    @footer      = iiin "footer"
    content      = readfile "rp/#{@params.char}/bio.html"