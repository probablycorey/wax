-- Possibly throw this into the bridge
local namespace = {}
function namespace.objc(name)
  local metatable = {}
  metatable.__index = function(self, key) return oink.class[self.name .. key] end
  
  local n = setmetatable({}, metatable)
  n.name = name
  _G[name] = n
end

function namespace.struct(name)
  local metatable = {}
  metatable.__index = function(self, key) return oink.struct.pack(self.name .. key) end

  local n = setmetatable({}, metatable)
  n.name = name
  _G[name] = n
end


_G.namespace = namespace