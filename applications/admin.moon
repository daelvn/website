lapis = require "lapis"
iiin  = require "i18n"
fs    = require "filekit"

class Admn extends lapis.Application
  -- layout
  layout: require "views.layout"
  -- before
  @before_filter =>
    -- iframe header
    --@res.headers["X-Frame-Options"] = "SAMEORIGIN"
    -- helper functions
    @iiin = (...) => iiin ...
    -- set locale
    @session.locale = @params.lang or @session.locale or "en"
    iiin.loadFile "i18n/#{@session.locale}.lua"
    iiin.setLocale @session.locale
    -- check permissions
    @write redirect_to: "/login?redirect=#{@req.parsed_url.path}" unless @session.user and @session.user.admin
    -- @session.access or= "key:basic"
    -- checkAccess = require "util.access"
    -- levels      = require "static.lists.access"
    -- unless checkAccess "blog", levels[@session.access]
    --   return @write redirect_to: "/login?redirect=#{@req.parsed_url.path}"
  --# routes #--
  "/admin/newtoken": =>
    import new, close from require "controllers.tokens"
    token = new @params.scope or "basic"
    close!
    @html -> h1 token
