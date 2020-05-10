tasks:
  -- newcompile
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
  --
  run:   -> sh "lapis server development" -- runs the server
  setup: -> sh "moon util/db/setup.moon"  -- setup database
  -- installs dependencies
  install_deps: (get "install_deps") {
      "lapis", "i18n", "filekit", "inspect"
      "htmlparser", "moonscript", "grasp"
      "argon2", "openssl"
    }
  -- cleans useless files
  clean: ->
    for file in wildcard "**.lua"
      continue if file\match "lists/avatars"
      continue if file\match "hashes.lua"
      continue if file\match "alfons"
      fs.delete file
    for dir in wildcard "*_temp"
      fs.delete dir
    fs.delete "daelx.db"
  --
  genavatars: get "genavatars" -- generate avatar files
  unstyle:    get "unstyle"    -- unstyles poems in page/poetryrx/
  