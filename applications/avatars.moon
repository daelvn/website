lapis = require "lapis"


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
    -- check perms
    checkAccess = require "util.access"
    checkAccess @
  --# routes #--
  "/avatars": =>
    @title       = iiin "av_title"
    @description = iiin "av_description"
    @footer      = iiin "footer"
    render: "avatars"