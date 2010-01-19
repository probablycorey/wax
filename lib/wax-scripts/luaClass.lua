Object = {
  super = nil,
  
  init = function(self, ...)
    local instance = {}
    instance.super = self

    setmetatable(instance, {__index = function(self, key)
      return instance.super[key]
    end})

    if instance.__instanceInit then instance:__instanceInit(...) end
    
    return instance
  end,
}

function luaClass(options)
  local className = options[1]
  local superclass = options[2] or Object
  
  if type(superclass) == "string" then superclass = _G[superclass] end -- allow strings for superclass
    
  local class = superclass:init() 
  
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
