function string.unescape(url)
  url = string.gsub(url, "+", " ")
  url = string.gsub(url, "%%(%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
  end)  
  
  return url
end

function string.escape(s)
  s = string.gsub(s, "([&=+%c])", function (c)
    return string.format("%%%02X", string.byte(c))
  end)
  s = string.gsub(s, " ", "+")
  
  return s
end
