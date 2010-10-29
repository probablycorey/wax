function table.clone(t, nometa)
  local u = {}
  
  if not nometa then
    setmetatable(u, getmetatable(t))
  end
  
  for i, v in pairs(t) do
    if type(v) == "table" then
      u[i] = table.clone(v)
    else
      u[i] = v
    end
  end
  
  return u
end

function table.merge(t, u)
  local r = table.clone(t)
  
  for i, v in pairs(u) do
    r[i] = v
  end
  
  return r
end

function table.keys(t)
  local keys = {}
  for k, v in pairs(t) do table.insert(keys, k) end
  return keys
end

function table.unique(t)
  local seen = {}
  for i, v in ipairs(t) do
    if not table.includes(seen, v) then table.insert(seen, v) end
  end

  return seen
end

function table.values(t)
  local values = {}    
  for k, v in pairs(t) do table.insert(values, v) end  
  return values
end

function table.last(t)
  return t[#t]
end

function table.append(t, moreValues)
  for i, v in ipairs(moreValues) do
    table.insert(t, v)
  end
  
  return t
end

function table.indexOf(t, value)
  for k, v in pairs(t) do
    if v == value then return k end
  end
  
  return nil
end

function table.includes(t, value)
  return table.indexOf(t, value)
end

function table.removeValue(t, value)
  local index = table.indexOf(t, value)
  table.remove(t, index)
  return t
end

function table.each(t, func)
  for k, v in pairs(t) do
    func(v)
  end  
end

function table.find(t, func)
  for k, v in pairs(t) do
    if func(v) then return v end
  end
  
  return nil
end

function table.filter(t, func)
  local matches = {}
  for k, v in pairs(t) do
    if func(v) then table.insert(matches, v) end
  end
  
  return matches
end

function table.map(t, func)
  local mapped = {}
  for k, v in pairs(t) do
    table.insert(mapped, func(v, k))
  end
  
  return mapped
end

function table.groupBy(t, func)
  local grouped = {}
  for k, v in pairs(t) do
    local groupKey = func(v)
    if not grouped[groupKey] then grouped[groupKey] = {} end    
    table.insert(grouped[groupKey], v)
  end
  
  return grouped
end

function table.tostring(t, indent)
  local output = {}
  if type(t) == "table" then
    table.insert(output, "{\n")
    for k, v in pairs(t) do
      local innerIndent = (indent or " ") .. (indent or " ")
      table.insert(output, innerIndent .. tostring(k) .. " = ")
      table.insert(output, table.tostring(v, innerIndent))
    end
    
    if indent then
      table.insert(output, (indent or "") .. "},\n")
    else
      table.insert(output, "}")
    end
  else
    if type(t) == "string" then t = string.format("%q", t) end -- quote strings      
    table.insert(output, tostring(t) .. ",\n")
  end
  
  return table.concat(output)
end