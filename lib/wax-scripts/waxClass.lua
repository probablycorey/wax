function waxClass(className, superclassName, opts)
  local opts = opts or {}
  local class = wax.class(className, superclassName)

  for i, protocol in ipairs(opts.protocols or {}) do
    wax.class.addProtocols(class, protocol)
  end 

  local _M = setmetatable({}, {
    __newindex = function(self, key, value) 
      class[key] = value
    end,
    
    __index = _G;
    
    }
  )

  _G[className] = class
  package.loaded[className] = class
  setfenv(2, _M)
  
  return class
end
