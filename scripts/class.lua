function class(className, superclassName, opts)
  local opts = opts or {}
  local class = oink.class(className, superclassName)

  for i, protocol in ipairs(opts.protocols or {}) do
    oink.instance.setProtocols(class, protocol)
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