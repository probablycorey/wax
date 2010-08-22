function wax.autoload(...)
  local oldIndex = getmetatable(_G).__index
  local folders = {...}
  setmetatable(_G, {
    __index = function(self, key)
      local class = oldIndex(self, key)
      
      if class then return class end
      
      for i, folder in ipairs(folders) do
        local path = wax.root("scripts", folder, key .. ".lua")
        
        if wax.filesystem.exists(path) then 
          require(folder .. "." .. key)
          class = wax.class[key] or rawget(_G, key) -- try it again now
        end
      end
      
      return class
    end
  })
end