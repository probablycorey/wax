require "wax.ext"

require "wax.enums"
require "wax.structs"

require "wax.luaClass"
require "wax.waxClass"

require "wax.helpers"

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

-- Just a bunch of global helper functions

function IBOutlet(...)
  -- does nothing... just used so we can parse it
end

function putsLog()
  __puts_log__ = __puts_log__ or {}
  return __puts_log__
end

function clearPutsLog()
  __puts_log__ = nil
end

function puts(obj, ...)
  if type(obj) == "table" then 
    print(table.tostring(obj))
    return
  end
  
  if ... then obj = string.format(tostring(obj), ...) end
  
  -- Remove this! It's for debugging only!
  if #putsLog() > 100 then table.remove(putsLog(), 1) end
  table.insert(putsLog(), obj)
  
  print(obj)
end

function wax.guid()
  return NSProcessInfo:processInfo():globallyUniqueString()
end

function serialize(o, filename)
  local output = {}
  if type(o) == "number" or type(o) == "boolean" then
    table.insert(output, tostring(o))
  elseif type(o) == "string" then
    table.insert(output, string.format("%q", o))
  elseif type(o) == "table" then
    table.insert(output, "{\n")
    for k,v in pairs(o) do
      if type(k) == "string" then table.insert(output, "  [\"" .. k .. "\"] = ") 
      else table.insert(output, "  [" .. tostring(k) .. "] = ") end
      
      table.insert(output, serialize(v) .. ",\n")
    end
    table.insert(output, "}\n")
  else
    error("cannot serialize a " .. type(o))
  end
  
  output = table.concat(output, "")
  
  if filename then
    local f = assert(io.open(filename, "w"))
    f:write(output)
    f:close()
  end
  
  return output
end

function deserialize(filename)
  local f = io.open(filename, "r")
  if not f then return nil end

  local output = f:read("*all")
  local success, value = pcall(function() return loadstring("return " .. output)() end)
  return value
end