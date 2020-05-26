import config from require "util.config"
lapis            = require "lapis"

-- reads the contents of an html file
readfile = (file) ->
  --ngx.log ngx.NOTICE, "opening #{file.html} to display"
  local contents
  with io.open "#{file}.html", "r"
    contents = \read "*a"
    \close!
  return contents

class Homepage extends lapis.Application
  -- layout
  layout: require "views.layout"
  -- include applications
  apps = config.dxvn.apps
  for app, incl in pairs apps
    @include "applications.#{app}" if incl
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
  -- 404 Not Found
  handle_404: =>
    @title       = iiin "404_title"
    @description = iiin "404_description"
    @footer      = iiin "footer"
    render: "404", status: 404
  --# routes #--
  -- /
  "/": =>
    @title         = "dael."
    @description   = iiin "intro"
    @footer        = iiin "footer"
    @toast         = @session.toast if @session.toast
    @session.toast = nil
    render: "index"
  -- /empty
  "/empty": =>
    layout: false, " "
  -- /crawlspace
  "/crawlspace": =>
    render: "crawlspace"