function waxClass(options)
  local className = options[1]
  local superclassName = options[2]
  local class = wax.class(className, superclassName)

  for i, protocol in ipairs(options.protocols or {}) do
    wax.class.addProtocols(class, protocol)
  end 

  local _M = setmetatable({}, {
    __newindex = function(self, key, value) 
      class[key] = value
    end,
    
    __index = function(self, key) 
      return class[key] or _G[key]
    end,
    
    }
  )

  _G[className] = class
  package.loaded[className] = class
  setfenv(2, _M)
  
  return class
end
