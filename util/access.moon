return =>
  -- load access scopes
  import config from require "util.config"
  access = {"scope:"..k, v for k, v in pairs config.dxvn.access}
  scope  = @session.user and access[@session.user.scope] or access["scope:guest"]
  -- see our current path
  current = @req.parsed_url.path
  -- check that it matches
  patterns = [fs.fromGlob v for v in *scope]
  matched  = false
  for pat in *patterns
    if fs.matchGlob pat, current
      matched = true
      break
  -- return
  if matched
    return true
  elseif not @session.user
    @write redirect_to: "/login?redirect=#{@req.parsed_url.path}"
  else
    @title       = iiin "403_title"
    @description = iiin "403_description"
    @footer      = iiin "footer"
    @write render: "403"