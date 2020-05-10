-- Sets up the database
-- By daelvn
import config from require "util.config"
import sql    from require "grasp.query"
grasp            = require "grasp"

statements = {
  -- Create the users table
  sql -> create "users", -> columns:
    username:    "TEXT NOT NULL UNIQUE"
    password:    "TEXT NOT NULL"
    created_at:  "DATE NOT NULL"
    admin:       "BOOLEAN NOT NULL CHECK (admin IN (0,1))"
    forcechange: "BOOLEAN NOT NULL CHECK (forcechange IN (0,1))"
  -- Create a basic admin account
  -- Will be asked to change it immediately (forcechange)
  --"INSERT INTO users VALUES ('admin', '#{hashPassword "ddddd"}', date('now'), 1, 1)"
  -- sql -> insert into "users", -> values:
  --   username:    "admin"
  --   password:    "yeye"
  --   created:     raw "datetime('now')"
  --   admin:       true
  --   forcechange: true
  -- sql -> update "users", ->
  --   where username: "admin"
  --   values:
  --     password: "yoyo"
}

-- open database
assert config.daelvn.db,          "Database configuration not found"
assert config.daelvn.db.location, "Database location not specified"
import Database, update from grasp
db  = Database config.daelvn.db.location
run = update db

-- run statements
import errorFor from grasp
for stat in *statements
  unless run stat
    code, message = errorFor db
    error "Could not setup: [[#{stat}]] - (#{code}) #{message}"

-- close database
grasp.close db