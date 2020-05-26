import Entry, close from require "controllers.blog"
lapis                  = require "lapis"

class BlogAlt extends lapis.Application
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
  "/blogalt": =>
    @title       = iiin "b_title"
    @description = iiin "b_description"
    render: "blogalt"
  "/blogalt/:uid": =>
    entry = Entry @params.uid
    return status: 404 unless entry
    @title       = entry.name
    @description = iiin "b_description"
    close!
    return entry.content[@session.locale]