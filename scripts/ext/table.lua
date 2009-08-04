function table.clone(t, nometa)
  local u = {}
  
  if not nometa then
    setmetatable(u, getmetatable(t))
  end
  
  for i, v in pairs(t) do
    u[i] = v
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

function table.push(t, obj) 
  t[#t + 1] = obj 
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
