Object = {
  defaults = {},

  __call = function(self, values)
    local object = table.clone(Object)

    object.defaults = table.merge(self.defaults, values)
    object = table.merge(object, object.defaults)
    object.prototype = self
    
    return setmetatable(object, object)
  end,
  
  __index = function(self, value)
    return rawget(self, value) or (rawget(self, "prototype") and self.prototype[value])
  end,
}

setmetatable (Object, Object)
