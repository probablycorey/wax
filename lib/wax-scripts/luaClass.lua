Object = {
  super = nil,
  
  init = function(self, ...)
    local instance = {}
    instance.super = self

    instance.__index = function(self, key) return self.super[key] end
    setmetatable(instance, instance)

    -- If an init method is specified, then call it (It was renamed to __instanceInit in luaClass)
    if instance.__instanceInit then instance:__instanceInit(...) end
    
    return instance
  end,
}

function luaClass(options)
  local className = options[1]
  local superclass = options[2] or Object
  
  if type(superclass) == "string" then superclass = _G[superclass] end -- allow strings for superclass
    
  local class = superclass:init()
  class.className = className
  
  -- setup the files environment to look in the class heirarchy and then the global scope
   local _M = setmetatable({}, {
    __newindex = function(self, key, value) 
      if key == "init" then key = "__instanceInit" end -- so we match the obj-c style
      class[key] = value
    end,
    
    __index = function(self, key) 
      return class[key] or _G[key]
    end,
  })
  
  _G[className] = class
  package.loaded[className] = class
  setfenv(2, _M)
  
  return class
end