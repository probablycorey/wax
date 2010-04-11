require "wax.helpers.bit"
require "wax.helpers.callback"
require "wax.helpers.frame"
require "wax.helpers.storage"
require "wax.helpers.base64"
require "wax.helpers.time"
require "wax.helpers.cache"

function wax.alert(title, message, ...)
  local alert = UIAlertView:init()
  alert:setTitle(title)
  alert:setMessage(message)
  
  if not ... then
    alert:addButtonWithTitle("OK")
  else
    for i, name in ipairs{...} do
      alert:addButtonWithTitle(name)
    end
  end
  
  alert:show()
  
  return alert
end