wax.storage = {
  PATH = "__storage__",
  storage = function(self)
    local data = wax.cache.get(self.PATH)
    return data and NSKeyedUnarchiver:unarchiveObjectWithData(data) or {}
  end
}

setmetatable(wax.storage, { 
  __index = function(self, key) 
    return self:storage()[key]
  end,
  
  __newindex = function(self, key, value)
    local storage = self:storage()
    storage[key] = value
    
    wax.cache.set(self.PATH, NSKeyedArchiver:archivedDataWithRootObject(storage))
  end
})