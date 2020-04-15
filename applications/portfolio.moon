lapis   = require "lapis"
iiin    = require "i18n"

class Portfolio extends lapis.Application
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
    unless checkAccess "portfolio", levels[@session.access]
      return @write redirect_to: "/login?redirect=#{@req.parsed_url.path}"
  --# routes #--
  "/portfolio": =>
    @title       = iiin "pf_title"
    @description = iiin "pf_description"
    @footer      = iiin "footer"
    render: "portfolio"