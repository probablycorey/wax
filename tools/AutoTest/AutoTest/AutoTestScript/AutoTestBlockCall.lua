waxClass{"AutoTestBlockCall"}

function testStrBlock_str(self, block, str)
	self:ORIGtestStrBlock_str(block, str)
	print(block)
	print("lua block" .. tostring(block) .. " str=" .. str)
end

function testLuaCallVoidBlock(self, block)
	luaCallBlockReturnVoidWithObjectParam(block)
end

function testLuaCallBlockWithTwoObjectParam(self, block)
    local webView = UIView:init()
    luaCallBlockReturnVoidWithObjectParam(block, self, webView);
end

function test2LuaCallBlockWithTwoObjectParam_str(self, block, str)
	luaCallBlockReturnVoidWithObjectParam(block, str, {k1="v1", k2="v2"})
end

function testLuaCallBlockReturnIntWith5ciqfd( self, block )
local res = luaCallBlockWithParamsTypeArray(block, {"int","int", "long long", "float", "double"}, TEST_VALUE_INT, TEST_VALUE_LONG_LONG, TEST_VALUE_FLOAT, TEST_VALUE_DOUBLE);
assert(res == TEST_VALUE_INT, "TEST_VALUE_INT 不等")
print("LUA TEST SUCCESS: testLuaCallBlockReturnIntWith5ciqfd");
end

function testRecursiveBlock_bBlock(self, aBlock, bBlock)
	local webView = UIView:init()
	luaCallBlockReturnVoidWithObjectParam(aBlock, "abc", 
		toobjc(
			function(code, responseData)
				print("lua code=" .. code .. " responseData=" .. tostring(responseData))
			end
		):luaBlockWithParamsTypeArray({"void", "NSString *", "NSDictionary *"}), 
		self, webView)
end

function testReturnObjectBlock(self, block)
	local res = luaCallBlockReturnObjectWithObjectParam(block, "lua abdefg", {k1="v1", k2="v2"})
	print('lua ' .. tostring(res))
end

function testReturnDictObjectBlock(self, block)
	local res = luaCallBlockReturnObjectWithObjectParam(block, "lua abdefg", {k1="v1", k2="v2"})
	print('lua ' .. tostring(res))
	print(res["key1"])
end

function testReturnViewControllerObjectBlock(self, block)
	print('block=' .. tostring(block))
	local res = luaCallBlockReturnObjectWithObjectParam(block, "lua abdefg", {k1="v1", k2="v2"})
	print('lua res=' .. tostring(res))
	block = nil
end