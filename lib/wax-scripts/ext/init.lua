require "wax.ext.table"
require "wax.ext.string"
require "wax.ext.number"
require "wax.ext.http"

function IBOutlet(...)
  -- does nothing... just used so we can parse it
end

function printf(string, ...)
end

function puts(obj, ...)
  if type(obj) == "table" then 
    print(table.tostring(obj))
    return
  end
  
  if ... then obj = string.format(tostring(obj), ...) end
  
  print(obj)
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
