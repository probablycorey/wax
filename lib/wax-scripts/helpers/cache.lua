wax.cache = {}
setmetatable(wax.cache, wax.cache)


-- Returns contents of cache keys
--    key: string # value for cache
--    maxAge: number (optional) # max age of file in seconds
function wax.cache.get(key, maxAge)
  local path = wax.cache.pathFor(key)
  
  if not wax.filesystem.isFile(path) then return nil end  

  local fileAge = os.time() - wax.filesystem.attributes(path).modifiedAt
  if maxAge and fileAge > maxAge then
    return nil
  end

  local success, result = pcall(function()
    return NSKeyedUnarchiver:unarchiveObjectWithFile(path)
  end)
  
  if not success then -- Bad cache
    puts("Error: Couldn't read cache with key %s", key)
    wax.cache.clear(key)
    return nil
  else
    return result, fileAge
  end
end

-- Creates a cache for the key with contents
--    key: string # value for the cache
--    contents: object # whatever is NSKeyedArchive compatible
function wax.cache.set(key, contents)
  local path = wax.cache.pathFor(key)

  if not contents then -- delete the value from the cache
    wax.cache.clear(key)
  else
    local success = NSKeyedArchiver:archiveRootObject_toFile(contents, path)
    if not success then puts("Couldn't archive cache '%s' to '%s'", key, path) end    
  end
end

-- Removes specific keys from cache
function wax.cache.clear(...)
  for i, key in ipairs({...}) do
    local path = wax.cache.pathFor(key)
    wax.filesystem.delete(path)
  end
end

-- Removes entire cache dir
function wax.cache.clearAll()
  wax.filesystem.delete(NSCacheDirectory)
  wax.filesystem.createDir(NSCacheDirectory)
end

function wax.cache.pathFor(key)
  return NSCacheDirectory .. "/" .. wax.base64.encode(key)
end