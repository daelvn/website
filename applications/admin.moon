import respond_to from require "lapis.application"
lapis                = require "lapis"
csrf                 = require "lapis.csrf"
discount             = require "discount"

class Admin extends lapis.Application
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
    -- check perms
    checkAccess = require "util.access"
    checkAccess @
  --# routes #--
  -- /admin/newtoken
  "/admin/newtoken": =>
    import new, close from require "controllers.tokens"
    token = new @params.scope or "scope:basic"
    close!
    @html ->
      h1 token.token
      p  token.scope
  -- /admin/upload/blog
  "/admin/upload/blog": respond_to {
    GET: =>
      @csrf_token = csrf.generate_token @
      --
      @title       = iiin "admin_upload_blog"
      @description = "blog."
      @footer      = iiin "footer"
      render: "admin.upload.blog"
    POST: =>
      csrf.assert_token @
      --
      @html ->
        h1 @params.title
        raw (discount.compile @params.entry).body
  }