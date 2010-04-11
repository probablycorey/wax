wax.cache = {}
setmetatable(wax.cache, wax.cache)

-- Returns contents (as string) of cache key
--    key: string # value for cache
--    maxAge: number (optional) # max age of file in seconds
function wax.cache.get(key, maxAge)
  local path = wax.cache.pathFor(key)
  
  if not wax.filesystem.isFile(path) then return nil end  
  
  if maxAge then -- Only return file if it is younger than given time
    local modifiedAt = wax.filesystem.attributes(path).modifiedAt
    if maxAge > os.time() - modifiedAt then return nil end
  end
  
  return wax.filesystem.contents(path)
end

-- Creates a cache for the key with contents
--    key: string # value for the cache
--    contents: string # what to store in the file
function wax.cache.set(key, contents)
  local path = wax.cache.pathFor(key)

  if not contents then -- delete the value from the cache
    wax.cache.remove(key)
  else
    wax.filesystem.createFile(path, contents)
  end
end

-- Removes specific keys from cache
function wax.cache.remove(...)
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