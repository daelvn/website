-- Token management
-- By daelvn
import db                                 from require "util.db"
import unbool, first, writefile, readfile from require "util"
import config                             from require "util.config"
import sql                                from require "grasp.query"
grasp                                        = require "grasp"

-- Use lapis+sqlite or grasp backends
BACKENDS = {
  grasp:    {}
  lsqlite3: {}
}
Grasp = BACKENDS.grasp

-- create a new uid
newUID = ->
  uid = ""
  for i=1,5
    math.randomseed os.time! + i*i + i
    x = math.random 65, 122
    while (x > 90) and (x < 97)
      x = math.random 65, 122
    uid ..= string.char x
  uid

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

-- Get blog entry
Grasp.Entry = (uid, tcontent) ->
  expect 1, uid,      {"string"}
  expect 2, tcontent, {"table", "nil"}
  Grasp.init! unless IS_INIT
  this = squery sql -> select "*", ->
    From "blog"
    where :uid
  return false, "Entry not found" unless "table" == typeof this
  --
  this         = first this
  this.content = tcontent or {}
  unless tcontent
    for lang in *config.dxvn.languages
      this.content[lang] = readfile "#{config.dxvn.paths.blog}/#{lang}/#{this.filename}"
  --
  return typeset this, "Entry"

-- Creates a new blog entry
Grasp.new = (name, tcontent, ttitles) ->
  expect 1, name,     {"string"}
  expect 2, tcontent, {"table"}
  Grasp.init! unless IS_INIT
  uid      = newUID!
  filename = "#{os.date "%d.%m.%Y-#{uid}"}.html"
  -- add titles
  update_values = values:
    :uid
    :name
    :filename
    created_at: raw: "datetime('now')"
  for lang, title in pairs ttitles
    update_values.values["title_#{lang}"] = title
  -- update
  ok = update_ sql -> insert into "blog", -> update_values
  return lastError! unless ok
  -- write contents
  unless fs.exists config.dxvn.paths.blog
    fs.makeDir config.dxvn.paths.blog
  for lang, content in pairs tcontent
    unless fs.exists fs.combine config.dxvn.paths.blog, lang
      fs.makeDir fs.combine config.dxvn.paths.blog, lang 
    writefile "#{config.dxvn.paths.blog}/#{lang}/#{filename}", content
  -- return
  return Grasp.Entry uid

-- Edits a blog entry's titles
Grasp.update = (uid, ttitles) ->
  expect 1, uid,     {"string"}
  expect 2, ttitles, {"table"}
  log inspect ttitles
  Grasp.init! unless IS_INIT
  ok = update_ sql -> update "blog", ->
    where :uid
    values: ttitles
  return lastError! unless ok
  return true

-- Edits a blog's content
Grasp.edit = (uid, tcontent) ->
  expect 1, uid,      {"string"}
  expect 2, tcontent, {"table"}
  Grasp.init! unless IS_INIT
  entry = Grasp.Entry uid
  -- write contents
  unless fs.exists config.dxvn.paths.blog
    fs.makeDir config.dxvn.paths.blog
  for lang, content in pairs tcontent
    unless fs.exists fs.combine config.dxvn.paths.blog, lang
      fs.makeDir fs.combine config.dxvn.paths.blog, lang 
    writefile "#{config.dxvn.paths.blog}/#{lang}/#{entry.filename}", content

-- Deletes a blog entry
Grasp.delete = (uid) ->
  expect 1, uid, {"string"}
  Grasp.init! unless IS_INIT
  entry = Grasp.Entry uid
  for lang in *config.dxvn.languages
    fs.remove "#{config.dxvn.paths.blog}/#{lang}/#{entry.filename}"
  --
  ok = update_ sql -> delete ->
    From "blog"
    where :uid
  return lastError! unless ok
  return true

-- Get a list of all entries
Grasp.all = ->
  Grasp.init! unless IS_INIT
  return squery sql -> select "*", -> From "blog"

-- Return functions
assert config.dxvn.db, "Database configuration not found"
return BACKENDS[config.dxvn.db.backend or "grasp"]