function waxClass(options)
  local class = waxInlineClass(options)
  setfenv(2, class._M)
  return class
end

-- So you can create a class without screwing with the function environment
function waxInlineClass(options)
  local className = options[1]
  local superclassName = options[2]
  local class = wax.class(className, superclassName)
  class.className = className

  if options.protocols then
    if type(options.protocols) ~= "table" then options.protocols = {options.protocols} end
    if #options.protocols == 0 then error("\nEmpty protocol table for class " .. className .. ".\n Make sure you are defining your protocols with a string and not a variable. \n ex. protocols = {\"UITableViewDelegate\"}\n\n") end
  end

  for i, protocol in ipairs(options.protocols or {}) do
    wax.class.addProtocols(class, protocol)
  end

  class._M = setmetatable({
      self = class,
    },
    {
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

  return class
end
