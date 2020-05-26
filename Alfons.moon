DEPENDENCIES = {    
  "lapis", "i18n", "filekit", "inspect"
  "htmlparser", "moonscript", "grasp"
  "argon2", "openssl", "discount"
}

-- Tasks --
tasks:
  -- compile
  compile: (...) =>
    flags = toflags ...
    if flags.noskip
      for file in wildcard "**.moon"
        continue if file\match "Alfons"
        moonc file
    else
      build (wildcard "**.moon"), (file) ->
        return if file\match "Alfons"
        moonc file
  -- cleans useless files
  clean: ->
    for file in wildcard "**.lua"
      continue if file\match "lists/avatars"
      continue if file\match "hashes.lua"
      continue if file\match "alfons"
      fs.delete file
    for dir in wildcard "*_temp"
      fs.delete dir
    fs.delete "dxvn.db"
  -- fast run
  run:  => tasks.fast!
  fast: =>
    print style "%{blue}:%{white} Running server..." 
    tasks.compile!
    tasks.server!
  -- slow run
  slow: =>
    print style "%{blue}:%{white} Running server (slow)..."
    tasks.clean!
    tasks.setup!
    tasks.compile "noskip"
    tasks.server!
  --
  server:     -> sh  "lapis server development"   -- runs the server
  setup:      -> sh  "moon util/db/setup.moon"    -- setup database  
  genavatars:    get "genavatars"                 -- generate avatar files
  unstyle:       get "unstyle"                    -- unstyles poems in page/poetryrx/ 
  install_deps: (get "install_deps") DEPENDENCIES -- installs dependencies
  install_js: -> sh  "bower install simplemde"