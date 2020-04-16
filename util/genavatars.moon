fs      = require "filekit"
avatars = fs.list1 "static/img/avatar/"
pp      = (t) -> print ("  " .. t)

prev = {}
if fs.exists "static/lists/avatars.old.lua"
  prev = dofile "static/lists/avatars.old.lua"

print "return {"
for file in *avatars
  pp "[\"#{file}\"] = \"#{prev[file] and prev[file] or ""}\","
print "}"
