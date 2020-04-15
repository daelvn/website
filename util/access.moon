(this, level) ->
  -- this: application we're on
  -- level: list of applications this access key can access
  -- (return) whether the page can be accessed or not
  for app in *level
    return true if app == "*"
    return true if app == this
  return false