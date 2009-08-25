require "oink"
require "luaspec"

require "objcToLuaTest"
require "instanceTest"
require "classTest"
require "protocolTest"
require "structTest"
require "gcTest"

spec:report(true)

-- saved = {}
-- 
-- function go()
--   -- puts("create saved number")
--   -- local savedNumber = oink.class.SimpleObject:initWithValue("1234")
--   puts("create letter")  
--   local letter = oink.class.SimpleObject:initWithValue("abcd")
-- 
--   puts("store letter")  
--   oink.class.SimpleObject:stored(letter)
--   
--   table.insert(saved, savedNumber)
-- end
-- 
-- go()
-- 
-- puts("Collecting garbage!")
-- 
-- collectgarbage("collect")
-- 
-- puts("getting stored letter")
-- 
-- puts(oink.class.SimpleObject:stored())
-- --oink.class.SimpleObject:stored(saved[1])
-- oink.class.SimpleObject:stored(1)
-- 
-- collectgarbage("collect")
-- 
-- print("Script done!")