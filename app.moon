lapis   = require "lapis"
iiin    = require "i18n"

class Homepage extends lapis.Application
  -- layout
  layout: require "views.layout"
  -- include applications
  apps = require "static.lists.applications"
  for app in *apps
    @include "applications.#{app}"
  -- before
  @before_filter =>
    -- helper functions
    @iiin = (...) => iiin ...
    -- set locale
    @session.locale = @params.lang or @session.locale or "en"
    iiin.loadFile "i18n/#{@session.locale}.lua"
    iiin.setLocale @session.locale
  -- 404 Not Found
  handle_404: =>
    @title       = iiin "404_title"
    @description = iiin "404_description"
    @footer      = iiin "footer"
    render: "404", status: 404
  --# routes #--
  -- /
  "/": =>
    @title       = "dael."
    @description = iiin "intro"
    @footer      = iiin "footer"
    render: "index"