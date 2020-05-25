import respond_to from require "lapis.application"
lapis                = require "lapis"
csrf                 = require "lapis.csrf"
iiin                 = require "i18n"
fs                   = require "filekit"

-- passwords
passwords = require "secrets.passwords"

class Access extends lapis.Application
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
    -- login
    -- @session.access or= "key:basic"
    -- if @params.password
    --   for pwd, key in pairs passwords
    --     if pwd == @params.password
    --       @session.access = key
    --   if @params.redirect
    --     return @write redirect_to: @params.redirect
    --   else
    --     return @write redirect_to: "/"
  --# routes #--
  -- /login
  "/login": respond_to {
    GET: =>
      @csrf_token = csrf.generate_token @
      --
      @title  = iiin "login"
      @footer = iiin "footer"
      render: "login"
    POST: =>
      csrf.assert_token @
      import User, auth, close from require "controllers.users"
      user, err = User @params.username
      unless user
        @errorid = "e_user_not_found"
        render: "error"
      --
      hasAuth = auth user, @params.password
      close!
      if hasAuth
        @session.user  = user
        @session.toast = iiin "logged", user: @params.username
        return redirect_to: @params.redirect or "/"
      else
        @errorid = "e_invalid_password"
        render: "error"
  }
  -- /logout
  "/logout": =>
    @session.user = nil
    redirect_to: "/"
  -- /register
  "/register": respond_to {
    GET: =>
      @csrf_token = csrf.generate_token @
      --
      @title  = iiin "register"
      @footer = iiin "footer"
      render: "register"
    POST: =>
      csrf.assert_token @
      import Token from require "controllers.tokens"
      tkn = Token @params.regtoken
      unless tkn
        @errorid = "e_invalid_token"
        return render: "error"
      import new, close from require "controllers.users"
      user, err = new @params.username, @params.password, (tkn.scope or "scope:basic"), false
      close!
      switch typeof user
        when "User"
          log "created user #{@params.username} with permissions #{tkn.scope}"
          return redirect_to: "/login"
        else
          @errorid = "e_user_exists"
          return render: "error"
  }
  -- /whoami
  "/whoami": =>
    if @session.user
      return @html -> h1 @session.user.username
    else
      return @html -> h1 "?"