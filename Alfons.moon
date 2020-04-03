tasks:
  always: ->
    for file in wildcard "**.moon"
      moonc file
  run: ->
    sh "lapis server development"
  clean: ->
    for file in wildcard "**.lua"
      fs.delete file
    for dir in wildcard "*_temp"
      fs.delete dir
