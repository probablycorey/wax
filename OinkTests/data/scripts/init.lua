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
--   letter.name = "hello!"
-- 
--   puts("store letter")  
--   oink.class.SimpleObject:stored(letter)
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
-- puts(oink.class.SimpleObject:stored().name)
-- oink.class.SimpleObject:stored(3)
-- 
-- collectgarbage("collect")
-- 
-- puts(oink.class.SimpleObject:stored())
-- 
-- print("Script done!")