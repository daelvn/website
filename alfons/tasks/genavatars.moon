->
  sh "mv static/lists/avatars.lua static/lists/avatars.old.lua"
  sh "moon util/genavatars.moon > static/lists/avatars.lua"