-- User management
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

--# Grasp backend #--
local IS_INIT
local squery, update, lastError

Grasp.init = ->
  squery    = grasp.squery db
  update    = grasp.update db
  lastError = grasp.errorFor db
  IS_INIT   = true

-- User :: string -> User
-- User {
--   username    :: string
--   password    :: string
--   admin       :: boolean
--   forcechange :: boolean
--   created_at  :: ?
-- }
-- User : update - updates the user with the new data
-- Creates a new user
Grasp.User = (username) ->
  expect 1, username, {"string"}
  Grasp.init! unless IS_INIT
  this = first squery sql -> select "*", ->
    From "users"
    where :username
  return false, "User not found" unless this
  --
  this.admin       = unbool this.admin
  this.forcechange = unbool this.forcechange
  return typeset this, "User"

-- Updates an User
-- Takes an optional username field, in case there's a new username
Grasp.update = (username=@username) =>
  expect 1, @, {"User"}
  Grasp.init! unless IS_INIT
  ok = update sql -> update "users", ->
    where username: username or @username
    values: @
  return lastError! unless ok
  return true

-- Auths an user
Grasp.auth = (password) =>
  expect 1, @,        {"User"}
  expect 2, password, {"string"}
  Grasp.init! unless IS_INIT
  vp = (verifyPassword password, @password)
  return vp, vp and "Correct password" or "Invalid password"

-- Creates a new user
Grasp.new = (username, password, admin=false) ->
  expect 1, username, {"string"}
  expect 2, password, {"string"}
  expect 3, admin,    {"boolean"}
  --ngx.log ngx.NOTICE, "creatin new user"
  Grasp.init! unless IS_INIT
  forcechange = admin
  ok = update sql -> insert into "users", -> values:
    :username
    :admin
    :forcechange
    password:   hashPassword password
    created_at: raw "datetime('now')"
  return lastError! unless ok
  return Grasp.User username

-- Return functions
assert config.daelvn.db, "Database configuration not found"
return BACKENDS[config.daelvn.db.backend or "grasp"]