-- Token management
-- By daelvn
import db            from require "util.db"
import unbool, first from require "util"
import config        from require "util.config"
import sql           from require "grasp.query"
grasp                   = require "grasp"

-- Use lapis+sqlite or grasp backends
BACKENDS = {
  grasp:    {}
  lsqlite3: {}
}
Grasp = BACKENDS.grasp

--# Grasp backend #--
local IS_INIT
local squery, update_, lastError

Grasp.init = ->
  squery     = grasp.squery db
  update_    = grasp.update db
  lastError  = grasp.errorFor db
  IS_INIT    = true

-- Close db
Grasp.close = ->
  Grasp.init! unless IS_INIT
  grasp.close db

-- Get a list of all categories
Grasp.all = ->
  Grasp.init! unless IS_INIT
  cats = squery sql -> select "*", -> From "categories"
  return [cat for {name: cat} in *t]

-- Return functions
assert config.dxvn.db, "Database configuration not found"
return BACKENDS[config.dxvn.db.backend or "grasp"]