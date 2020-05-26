import Entry, close from require "controllers.blog"
import config       from require "util.config"
import readfile     from require "util"
lapis                  = require "lapis"

class Blog extends lapis.Application
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
  "/blog": =>
    @title       = iiin "b_title"
    @description = iiin "b_description"
    render: "blog"
  "/blog/:uid": =>
    entry = Entry @params.uid
    return status: 404 unless entry
    @title       = entry.name
    @description = iiin "b_description"
    close!
    return entry.content[@session.locale]
  "/blog/raw/:locale/:uid": =>
    entry = Entry @params.uid
    return status: 404 unless entry
    close!
    return layout: false, content_type: "text/plain", readfile "#{config.dxvn.paths.blog}/#{@params.locale}/#{entry.filename}.md" 