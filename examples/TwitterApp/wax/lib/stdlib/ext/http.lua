if not wax.http then return end -- Only load if the wax.http extension has been loaded

function wax.http.post(options)
  options["method"] = "POST"
  return wax.http.request(options)
end

function wax.http.get(options)
  options["method"] = "GET"
  return wax.http.request(options)
end

function wax.http.delete(options)
  options["method"] = "DELETE"
  return wax.http.request(options)
end

function wax.http.put(options)
  options["method"] = "PUT"
  return wax.http.request(options)
end

function wax.http.escapeParams(params, prefix)
  if not params then return nil end
  if type(params) == "string" then return params end

  local params = table.map(params, function(value, key)
    if type(value) == "table" then
      return wax.http.escapeParams(value, key) 
    else value = string.escape(tostring(value)) 
      if prefix then 
        if type(key) == "number" then 
          key = ("%s[]"):format(prefix) -- If it is a number, treat it as an array
        else
          key = ("%s[%s]"):format(prefix, key) 
        end
      end    
      return key .. "=" .. value
    end
  end)
  
  return table.concat(params, "&")
end