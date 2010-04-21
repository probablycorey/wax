require "wax.luaspec"

require "tests.objcToLuaTest"
require "tests.instanceTest"
require "tests.classTest"
require "tests.protocolTest"
require "tests.structTest"
require "tests.gcTest"
require "tests.jsonTest"
require "tests.xmlTest"

puts("\nResults\n-------")
spec:report()