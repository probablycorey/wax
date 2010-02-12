require "wax.luaspec"

require "tests.objcToLuaTest"
require "tests.instanceTest"
require "tests.classTest"
require "tests.protocolTest"
require "tests.structTest"
require "tests.gcTest"

puts("")
puts("Results")
puts("-------")
spec:report()
exitApp()