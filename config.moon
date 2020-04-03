config = require "lapis.config"

config "development", ->
  port 6563

config "production", ->
  port        6563
  num_workers 4
  code_cache  "on"
