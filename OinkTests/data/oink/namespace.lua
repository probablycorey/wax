-- Possibly throw this into the bridge
_G.namespace = function(name)
  local metatable = {}
  metatable.__index = function(self, key) return oink.class[self.name .. key] end
  
  local n = setmetatable({}, metatable)
  n.name = name
  _G[name] = n
end