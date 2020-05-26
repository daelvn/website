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

  dxvn ->
    apps ->
      -- pages depend on these
      social   true
      access   true
      admin    true
      -- other sections
      blog     true
      poetry   true
      roleplay true
      avatars  true
    sections {
      "poetry"
      "blog"
      "roleplay"
      "avatars"
    }
    scopes ->
      default  "scope:basic"
      admin    "scope:admin"
    access ->
      admin    {"**"}
      none     {}
      guest    {"**"}
      basic    {"poetry/**", "blog/**"}
      roleplay {"**"}
    paths ->
      blog "page/blog/"
    languages {
      -- note: static/lua/simplemde.moon cannot load this file, so its languages must be changed manually
      "en", "es"
    }
    db ->
      backend  "grasp"
      location "dxvn.db"

config "production", ->
  num_workers  4
  code_cache   "on"
