lapis = require "lapis"
iiin  = require "i18n"

class Avatars extends lapis.Application
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
    checkAccess       = require "util.access"
    levels            = require "static.lists.access"
    unless checkAccess "avatars", levels[@session.access]
      return @write redirect_to: "/login?redirect=#{@req.parsed_url.path}"
  --# routes #--
  "/avatars": =>
    @title       = iiin "av_title"
    @description = iiin "av_description"
    @footer      = iiin "footer"
    render: "avatars"