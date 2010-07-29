wax.storage = {
  PATH = "__storage__",
  storage = function()
    return wax.cache.get(wax.storage.PATH) or {}
  end,
  clear = function()
    wax.cache.clear(wax.storage.PATH)
  end
}

setmetatable(wax.storage, { 
  __index = function(self, key) 
    return self:storage()[key]
  end,
  
  __newindex = function(self, key, value)
    local s = self:storage()
    s[key] = value
    wax.cache.set(self.PATH, s)
  end
})