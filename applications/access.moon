lapis   = require "lapis"
iiin    = require "i18n"
fs      = require "filekit"

-- passwords
passwords = require "secrets.passwords"

class Access extends lapis.Application
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
    -- login
    @session.access or= "key:basic"
    if @params.password
      for pwd, key in pairs passwords
        if pwd == @params.password
          @session.access = key
      if @params.redirect
        return @write redirect_to: @params.redirect
      else
        return @write redirect_to: "/"
  --# routes #--
  -- /login
  "/login": =>
    @title  = iiin "login"
    @footer = iiin "footer"
    render: "login"
  -- /logout
  "/logout": =>
    @session.access = "key:basic"
    redirect_to: "/"