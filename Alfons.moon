tasks:
  -- compiles moonscript files
  compile: ->
    for file in wildcard "**.moon"
      continue if file\match "Alfons"
      moonc file
  -- runs the server
  run: ->
    sh "lapis server development"
  -- installs dependencies
  install_deps: ->
    deps = {
      "lapis"
      "i18n"
      "filekit"
      "inspect"
      "htmlparser"
    }
    for dep in *deps
      print "==> installing dependency: #{dep}"
      sh "luarocks install #{dep}"
  -- installs dependencies
  install_deps: (bin="luarocks") =>
    deps = {
      "lapis"
      "i18n"
      "filekit"
      "inspect"
      "htmlparser"
      "moonscript"
    }
    for dep in *deps
      print "==> installing dependency: #{dep}"
      sh "#{bin} install #{dep}"
  -- cleans useless files
  clean: ->
    for file in wildcard "**.lua"
      continue if file\match "lists/avatars"
      fs.delete file
    for dir in wildcard "*_temp"
      fs.delete dir
  -- generate avatar files
  genavatars: ->
    sh "mv static/lists/avatars.lua static/lists/avatars.old.lua"
    sh "moon util/genavatars.moon > static/lists/avatars.lua"
  -- unstyles poems in page/poetryrx/
  unstyle: ->
    inspect = require "inspect"
    html    = require "htmlparser"
    displayed = false
    for file in wildcard "poetryrx/**.html"
      -- read DOM
      local root
      with fs.safeOpen file, "r"
        if .error
          print "could not read file #{file}"
          continue
        content = \read "*a"
        root    = html.parse content
        \close!
      -- get contents of div#write
      continue unless root.nodes[1]
      continue if     root.nodes[1].name != "html"
      --     root.html    .body    .div#write
      print file
      body = root.nodes[1].nodes[2].nodes[1]\getcontent!
      -- write back into file
      with fs.safeOpen file, "w"
        if .error
          print "could not write file #{file}"
          continue
        \write body
        \close!