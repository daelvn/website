return function()
  sh("mv static/lists/avatars.lua static/lists/avatars.old.lua")
  return sh("moon util/genavatars.moon > static/lists/avatars.lua")
end
