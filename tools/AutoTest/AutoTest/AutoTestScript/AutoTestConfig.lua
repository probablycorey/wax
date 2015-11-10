print("wax.isArm64=" .. tostring(wax.isArm64))

if wax.isArm64 == true then
	TEST_VALUE_INTEGER = 1234567890123
else
    TEST_VALUE_INTEGER = 1234567
end

if wax.isArm64 == true then
	TEST_VALUE_U_INTEGER = 12345678901234
else
	TEST_VALUE_U_INTEGER = 12345678
end
TEST_VALUE_SHORT = 12345
TEST_VALUE_INT = 123456
TEST_VALUE_LONG_LONG = 1234567890123456
TEST_VALUE_U_LONG_LONG  = 12345678901234567
TEST_VALUE_CHAR_POINTER = "abc"
TEST_VALUE_VOID_POINTER = "efg"

TEST_VALUE_CHAR = 97
TEST_VALUE_BOOL = true
TEST_VALUE_bool = false

TEST_VALUE_FLOAT = 123.456
TEST_VALUE_CGFLOAT = 1234.5678
TEST_VALUE_DOUBLE = 12345.6789
TEST_VALUE_STRING = "abcdefg"


function isDoubleEqual(a, b)
	
	local res = math.abs(a-b)<0.0001
	print(res, a, b)
	return res
end

-- function toblock(func, paramTypes)
-- if paramTypes == nil then
-- return toobjc(func):luaVoidBlock()
-- else
-- return toobjc(func):luaBlockWithParamsTypeArray(paramTypes)
-- end
-- end