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
    
  for k, v in pairs(t) do
    table.insert(keys, k)
  end
  
  return keys
end

function table.map(t, func)
  local mapped = {}
  for k, v in pairs(t) do
    table.insert(mapped, func(k, v))
  end
  
  return mapped
end

-- TMP --
function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    local sb = {}
    for key, value in pairs (tt) do
      table.insert(sb, string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        table.insert(sb, "{\n");
        table.insert(sb, table_print (value, indent + 2, done))
        table.insert(sb, string.rep (" ", indent)) -- indent it
        table.insert(sb, "}\n");
      elseif "number" == type(key) then
        table.insert(sb, string.format("\"%s\"\n", tostring(value)))
      else
        table.insert(sb, string.format(
            "%s = \"%s\"\n", tostring (key), tostring(value)))
       end
    end
    return table.concat(sb)
  else
    return tt .. "\n"
  end
end

function table.print(tbl)
  if "nil" == type(tbl) then
    print(tostring(nil))
  elseif "table" == type(tbl) then
    print(table_print(tbl))
  elseif "string" == type(tbl) then
    print(tbl)
  else
    print(tostring(tbl))
  end
end
