-- Token management
-- By daelvn
import hashPassword, verifyPassword from require "util.auth"
import db                           from require "util.db"
import unbool, first                from require "util"
import config                       from require "util.config"
import sql                          from require "grasp.query"
grasp                                  = require "grasp"

-- Use lapis+sqlite or grasp backends
BACKENDS = {
  grasp:    {}
  lsqlite3: {}
}
Grasp = BACKENDS.grasp

-- create a new token
token = ->
  tkn = ""
  for i=1,5
    math.randomseed os.time! + i*i + i
    x = math.random 65, 122
    while (x > 90) and (x < 97)
      x = math.random 65, 122
    tkn ..= string.char x
  tkn

--# Grasp backend #--
local IS_INIT
local squery, update, lastError

Grasp.init = ->
  squery    = grasp.squery db
  update    = grasp.update db
  lastError = grasp.errorFor db
  IS_INIT   = true

-- Close db
Grasp.close = ->
  Grasp.init! unless IS_INIT
  grasp.close db

-- get token
Grasp.Token = (tkn) ->
  expect 1, tkn, {"string"}
  Grasp.init! unless IS_INIT
  this = squery sql -> select "*", ->
    From "tokens"
    where token: tkn
  return false, "Token not found" unless "table" == typeof this
  --
  return typeset (first this), "Token"

-- create a new token
Grasp.new = (scope="scope:basic") ->
  expect 1, scope, {"string"}
  Grasp.init! unless IS_INIT
  tkn = token!
  ok = update sql -> insert into "tokens", -> values:
    :scope
    token: tkn
  return lastError! unless ok
  return (Grasp.Token tkn), tkn

-- Return functions
assert config.daelvn.db, "Database configuration not found"
return BACKENDS[config.daelvn.db.backend or "grasp"]