return function()
  local inspect = require("inspect")
  local html = require("htmlparser")
  local displayed = false
  for file in wildcard("poetryrx/**.html") do
    local _continue_0 = false
    repeat
      local root
      do
        local _with_0 = fs.safeOpen(file, "r")
        if _with_0.error then
          print("could not read file " .. tostring(file))
          _continue_0 = true
          break
        end
        local content = _with_0:read("*a")
        root = html.parse(content)
        _with_0:close()
      end
      if not (root.nodes[1]) then
        _continue_0 = true
        break
      end
      if root.nodes[1].name ~= "html" then
        _continue_0 = true
        break
      end
      print(file)
      local body = root.nodes[1].nodes[2].nodes[1]:getcontent()
      do
        local _with_0 = fs.safeOpen(file, "w")
        if _with_0.error then
          print("could not write file " .. tostring(file))
          _continue_0 = true
          break
        end
        _with_0:write(body)
        _with_0:close()
      end
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
end
