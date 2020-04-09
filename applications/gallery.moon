lapis = require "lapis"
iiin  = require "i18n"

class Gallery extends lapis.Application
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
  "/gallery": =>
    @title       = iiin "g_index"
    @description = iiin "g_description"
    @footer      = iiin "footer"
    render: "gallery"