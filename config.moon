config = require "lapis.config"

-- reads the contents of a file
readfile = (file) ->
  local contents
  with io.open "#{file}", "r"
    contents = \read "*a"
    \close!
  return contents

config {"development", "production"}, ->
  bind_host    "0.0.0.0"
  secret       readfile "secrets/secret.txt"
  session_name "daelx_session"
  port 6563

  daelvn ->
    db ->
      backend  "grasp"
      location "daelx.db"

config "production", ->
  num_workers  4
  code_cache   "on"
