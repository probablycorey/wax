-- Let's us cancel a callback

wax.callback = function(callback)
  local object = {callback = callback}

  function object.cancel(self)
    self.canceled = true
  end
  
  function object.__call(self, ...)
    if self.canceled then 
      return 
    end
    
    local args = self.scope and {self.scope, ...} or {...}
    self.callback(unpack(args))
  end

  setmetatable(object, object)
  
  return object
end
