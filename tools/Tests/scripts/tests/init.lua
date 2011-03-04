require "wax.luaspec"

require "tests.classTest"
require "tests.objcToLuaTest"
require "tests.instanceTest"
require "tests.protocolTest"
require "tests.structTest"
require "tests.gcTest"
require "tests.jsonTest"
require "tests.xmlTest"
require "tests.base64Test"

puts("\nResults\n-------")
spec:report()
