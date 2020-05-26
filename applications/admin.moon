import respond_to from require "lapis.application"
import config     from require "util.config"
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
      -- (discount.compile @params.entry).body
      -- create markdown entry list
      tmarkdown = {}
      for lang in *config.dxvn.languages
        tmarkdown[lang] = @params["entry_#{lang}"]
      -- compile markdown
      tcontent = {lang, (discount.compile content).body for lang, content in pairs tmarkdown}
      log inspect tcontent
      -- insert into database and write
      import new, close from require "controllers.blog"
      new @params.title, tcontent
      close!
      -- render
      @html ->
        h1 "wrote blog"
  }