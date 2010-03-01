require "wax.ext"

require "wax.enums"
require "wax.structs"

require "wax.luaClass"
require "wax.waxClass"
require "wax.waxCallback"
require "wax.cocoaNamespace"

require "wax.bit"

cocoaNamespace("UI")
cocoaNamespace("NS")
cocoaNamespace("MK")
cocoaNamespace("MF")

function wax.guid()
  return NS.ProcessInfo:processInfo():globallyUniqueString()
end