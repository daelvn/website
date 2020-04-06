lapis = require "lapis"
inspect = require "inspect"
iiin  = require "i18n"

class Homepage extends lapis.Application
  -- layout
  layout: require "views.layout"
  -- i18n
  @before_filter =>
    -- helper functions
    @iiin   = (...) => iiin ...
    -- set locale
    locale = @params.lang or "en"
    iiin.loadFile "i18n/#{locale}.lua"
    iiin.setLocale locale
  -- routes
  "/": =>
    @title       = "example page"
    @description = "just an example"
    @footer      = iiin "footer"
    render: "index"
