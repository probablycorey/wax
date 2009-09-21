Object = {
  defaults = {},

  __call = function(self, values)
    local object = table.clone(Object)

    object.defaults = table.merge(self.defaults, values or {})
    object = table.merge(object, object.defaults)
    object.prototype = self
    
    return setmetatable(object, object)
  end,
  
  __index = function(self, value)
    return rawget(self, value) or (rawget(self, "prototype") and self.prototype[value])
  end,
  
  data = function(self)
    local data = {}
    
    for k, v in pairs(self) do
      if type(v) == "number" or 
         type(v) == "string" or
         type(v) == "boolean" or
         (type(v) == "table" and k ~= "prototype" and k ~= "defaults") then         
         data[k] = v
      end
    end    
    
    return data
  end,
}

setmetatable(Object, Object)
