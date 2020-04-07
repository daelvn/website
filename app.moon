lapis   = require "lapis"
iiin    = require "i18n"
inspect = require "inspect"

class Homepage extends lapis.Application
  -- layout
  layout: require "views.layout"
  -- include applications
  @include "applications.poetry"
  -- before
  @before_filter =>
    -- helper functions
    @iiin = (...) => iiin ...
    -- set locale
    @session.locale = @params.lang or @session.locale or "en"
    iiin.loadFile "i18n/#{@session.locale}.lua"
    iiin.setLocale @session.locale
  --# routes #--
  -- /
  "/": =>
    @title       = "example page"
    @description = "just an example"
    @footer      = iiin "footer"
    render: "index"