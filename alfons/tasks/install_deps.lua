return function(deps)
  return function(self, bin)
    if bin == nil then
      bin = "luarocks"
    end
    for _index_0 = 1, #deps do
      local dep = deps[_index_0]
      print("==> installing dependency: " .. tostring(dep))
      sh(tostring(bin) .. " install " .. tostring(dep))
    end
  end
end
