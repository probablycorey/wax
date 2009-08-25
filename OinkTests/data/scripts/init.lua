require "oink"
require "luaspec"

require "objcToLuaTest"
require "instanceTest"
require "classTest"
require "protocolTest"
require "structTest"
require "gcTest"

spec:report(true)

-- function go()
--   local value = oink.class.SimpleObject:initWithValue("23")
-- end
-- 
-- go()
-- collectgarbage("collect")
-- 
-- print("done!")