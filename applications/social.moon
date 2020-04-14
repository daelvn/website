lapis = require "lapis"
iiin  = require "i18n"

class Social extends lapis.Application
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
  "/sn/discord": =>
    @title       = "discord."
    @description = "daelvn#2643"
    render: "discord"
  "/sn/spotify":   => redirect_to: "https://open.spotify.com/user/daelvn?si=900hw_R1QHeOqU1NHF5E8Q"
  "/sn/github":    => redirect_to: "https://github.com/daelvn"
  "/sn/instagram": => redirect_to: "https://instagram.com/thecrimulo"
  "/sn/mail":      => redirect_to: "mailto:daelvn@gmail.com"