function string.unescape(url)
  url = string.gsub(url, "+", " ")
  url = string.gsub(url, "%%(%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
  end)  
  
  return url
end

function string.split(s, sep)
  local t = {}
  for o in string.gmatch(s, "([^" .. (sep or " ") .. "]+)") do 
    table.insert(t, o) 
  end
  
  return t
end

function string.strip(s, pattern)
  pattern = pattern or "%s+"
  s = s:gsub("^" .. pattern, "")
  s = s:gsub(pattern .. "$", "")
  return s
end

function string.camelCase(s)
  local splitTable = s:split("_-")
  local result = table.remove(splitTable, 1)
  for i, chunk in ipairs(splitTable) do
    result = result .. chunk:sub(1,1):upper() .. chunk:sub(2)
  end
    
  return result
end

function string.escape(s)
  s = string.gsub(s, "([!%*'%(%);:@&=%+%$,/%?#%[%]<>~%.\"{}|\\%-`_%^%%%c])",
                  function (c)
                    return string.format("%%%02X", string.byte(c))
                  end)
  s = string.gsub(s, " ", "+")
  
  return s
end

function string.decodeEntities(s)
  local entities = {
    amp = "&",
    lt = "<",
    gt = ">",
    quot = "\"",
    apos = "'", 
    nbsp = " ",
    iexcl = "¡",
    cent = "¢",
    pound = "£",
    curren = "¤",
    yen = "¥",
    brvbar = "¦",
    sect = "§",
    uml = "¨",
    copy = "©",
    ordf = "ª",
    laquo = "«",
--    not = "¬",
    shy = "­",
    reg = "®",
    macr = "¯",
    deg = "°",
    plusmn = "±",
    sup2 = "²",
    sup3 = "³",
    acute = "´",
    micro = "µ",
    para = "¶",
    middot = "·",
    cedil = "¸",
    sup1 = "¹",
    ordm = "º",
    raquo = "»",
    frac14 = "¼",
    frac12 = "½",
    frac34 = "¾",
    iquest = "¿",
    times = "×",
    divide = "÷",   
  }
    
  return string.gsub(s, "&(%w+);", entities)
end

function string.caseInsensitive(s)
  s = string.gsub(s, "%a", function (c)
    return string.format("[%s%s]", string.lower(c), string.upper(c))
  end)
  return s
end
