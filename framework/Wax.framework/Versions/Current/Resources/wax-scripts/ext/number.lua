number = {}

local numberToMonth = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
function number.toMonth(n)
  n = tonumber(n)
  return numberToMonth[n]
end

function number.tocurrency(n)
  return "$" .. number.commaSeperate(n)
end

function number.commaSeperate(n)
  local formatted = tostring(n)
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if k ==0 then break end
  end
  
  return formatted
end
