config = require "lapis.config"

-- reads the contents of a file
readfile = (file) ->
  local contents
  with io.open "#{file}", "r"
    contents = \read "*a"
    \close!
  return contents

config "development", ->
  port 6563

config "production", ->
  session_name "daelfell_session"
  secret       readfile "secrets/secret.txt"
  port         6563
  num_workers  4
  code_cache   "on"
