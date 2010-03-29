wax.storage = {
  PATH = NSDocumentDirectory .. "/__storage__.plist",  
 
  storage = function(self)
    return NSDictionary:initWithContentsOfFile(self.PATH) or {}
  end
}

setmetatable(wax.storage, { 
  __index = function(self, key) 
    return self:storage()[key]
  end,
  
  __newindex = function(self, key, value)
    local storage = self:storage()
    storage[key] = value
    
    return toobjc(storage):writeToFile_atomically(self.PATH, true)
  end
})