import respond_to from require "lapis.application"
import config     from require "util.config"
import writefile  from require "util"
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
  -- /admin/edit
  "/admin/edit": => redirect_to: "/admin/manage"
  -- /admin/edit/blog
  "/admin/edit/blog": => redirect_to: "/admin/manage/blog"
  -- /admin/edit/blog/:uid
  "/admin/edit/blog/:uid": respond_to {
    GET: =>
      @csrf_token = csrf.generate_token @
      --
      @title       = iiin "admin_update_blog"
      @description = "blog."
      @footer      = iiin "footer"
      @uid         = @params.uid
      render: "admin.edit.blog"
    POST: =>
      csrf.assert_token @
      --
      -- (discount.compile @params.entry).body
      -- create markdown entry list
      import Entry, edit, close from require "controllers.blog"
      tmarkdown = {}
      for lang in *config.dxvn.languages
        tmarkdown[lang] = @params["entry_#{lang}"]
        writefile "#{config.dxvn.paths.blog}/#{lang}/#{(Entry @params.uid).filename}.md", @params["entry_#{lang}"]
      -- compile markdown
      tcontent = {lang, (discount.compile content).body for lang, content in pairs tmarkdown}
      log inspect tcontent
      -- insert into database and write
      edit @params.uid, tcontent
      close!
      --
      redirect_to: "/admin/manage/blog"
  }
  -- /admin/manage
  "/admin/manage": =>
    @html ->
      h1 iiin "admin_manage"
      for section in *config.dxvn.sections
        a href: "/admin/manage/#{section}", iiin "section_#{section}"
        br!
  -- /admin/manage/blog
  "/admin/manage/blog": respond_to {
    GET: =>
      @csrf_token = csrf.generate_token @
      --
      @title       = iiin "admin_manage_blog"
      @description = "blog."
      @footer      = iiin "footer"
      render: "admin.manage.blog"
    POST: =>
      csrf.assert_token @
      --
      import Entry, update, delete, close from require "controllers.blog"
      if @params.delete
        delete @params.delete
        close!
        return redirect_to: @req.parsed_url.path
      elseif @params.change
        ttitles = {}
        log inspect @params
        for lang in *config.dxvn.languages
          ttitles["title_#{lang}"] = @params["title_#{(Entry @params.change).name}_#{lang}"]
        --
        update @params.change, ttitles
        close!
        return redirect_to: @req.parsed_url.path
      elseif @params.edit
        return redirect_to: "/admin/edit/blog/#{@params.edit}"
      elseif @params.view
        return redirect_to: "/blog/#{@params.view}"
  }
  -- /admin/upload
  "/admin/upload": =>
    @html ->
      h1 iiin "admin_upload"
      for section in *config.dxvn.sections
        a href: "/admin/upload/#{section}", iiin "section_#{section}"
        br!
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
      -- create title list
      ttitles = {}
      for lang in *config.dxvn.languages
        ttitles[lang] = @params["title_#{lang}"]
      -- insert into database and write
      import new, close from require "controllers.blog"
      entry = new @params.title, tcontent, ttitles
      for lang in *config.dxvn.languages
        writefile "#{config.dxvn.paths.blog}/#{lang}/#{entry.filename}.md", @params["entry_#{lang}"]
      close!
      -- render
      @html ->
        h1 "wrote blog"
  }