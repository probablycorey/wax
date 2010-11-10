setmetatable(_G, {
  __index = function(self, key)
    local class = wax.class[key]
    if class then self[key] = class end -- cache it for future use
    
    if not class and key:match("^[A-Z][A-Z][A-Z]") then -- looks like they were trying to use an objective-c obj
      print("WARNING: No object named '" .. key .. "' found.")
    end
    
    return class
  end
})

require "wax.ext"
require "wax.enums"
require "wax.structs"
require "wax.waxClass"
require "wax.helpers"