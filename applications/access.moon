import respond_to from require "lapis.application"
import config     from require "util.config"
lapis                = require "lapis"
csrf                 = require "lapis.csrf"

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
      return render: "login"
    POST: =>
      csrf.assert_token @
      import User, auth, close from require "controllers.users"
      user, err = User @params.username
      unless user
        @errorid = "e_user_not_found"
        return render: "error"
      --
      hasAuth = auth user, @params.password
      close!
      if hasAuth
        @session.user  = user
        @session.toast = iiin "logged", user: @params.username
        return redirect_to: @params.redirect or "/"
      else
        @errorid = "e_invalid_password"
        return render: "error"
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
      -- validate register token
      import Token, delete from require "controllers.tokens"
      tkn = Token @params.regtoken
      unless tkn
        @errorid = "e_invalid_token"
        return render: "error"
      -- create user
      import new, close from require "controllers.users"
      user, err = new @params.username, @params.password, (tkn.scope or config.dxvn.scopes.default), (tkn.scope == config.dxvn.scopes.admin)
      -- validate user
      switch typeof user
        when "User"
          delete tkn.token
          close!
          return redirect_to: "/login"
        else
          @errorid = "e_user_exists"
          return render: "error"
  }
  -- /whoami
  "/whoami": =>
    if @session.user
      return @html ->
        h1 @session.user.username
        p "#{@session.user.scope}\n#{@session.user.created_at}\n#{@session.user.admin}"
    else
      return @html -> h1 "?"
  -- /tokens
  "/tokens": =>
    @html ->
      h1 @iiin "tokens_title"
      p  -> raw @iiin "tokens_description"