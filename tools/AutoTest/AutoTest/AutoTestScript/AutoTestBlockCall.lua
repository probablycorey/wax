waxClass{"AutoTestBlockCall"}

function testCallBlockInLua(self)
    local res = luaCallBlock(self:privateBlock(), TEST_VALUE_STRING);
    assert(res == TEST_VALUE_STRING .. TEST_VALUE_STRING, "testCallBlockInLua not equal")

	local res = luaCallBlockWithParamsTypeArray(self:privateBlock(), {"id", "id"}, TEST_VALUE_STRING);
	assert(res == TEST_VALUE_STRING .. TEST_VALUE_STRING, "testCallBlockInLua not equal")
end

function testStrBlock_str(self, block, str)
	self:ORIGtestStrBlock_str(block, str)
	print(block)
	print("lua block" .. tostring(block) .. " str=" .. str)
end

function testLuaCallVoidBlock(self, block)
	block()
	luaCallBlockWithParamsTypeArray(block, {"void"});
end

function testLuaCallBlockWithTwoObjectParam(self, block)
    local webView = UIView:init()
    block(self, webView);
    luaCallBlockWithParamsTypeArray(block, {"void","id", "id"}, self, webView);
end

function test2LuaCallBlockWithTwoObjectParam_str(self, block, str)
	block(str, {k1="v1", k2="v2"})
	luaCallBlockWithParamsTypeArray(block, {"void","id", "id"}, str, {k1="v1", k2="v2"})
end

function testLuaCallBlockReturnIntWith5ciqfd( self, block )
	local res = block(TEST_VALUE_INT, TEST_VALUE_LONG_LONG, TEST_VALUE_FLOAT, TEST_VALUE_DOUBLE);
	assert(res == TEST_VALUE_INT, "testLuaCallBlockReturnIntWith5ciqfd not equal")
	local res = luaCallBlockWithParamsTypeArray(block, {"int","int", "long long", "float", "double"}, TEST_VALUE_INT, TEST_VALUE_LONG_LONG, TEST_VALUE_FLOAT, TEST_VALUE_DOUBLE);
	assert(res == TEST_VALUE_INT, "testLuaCallBlockReturnIntWith5ciqfd not equal")
	print("LUA TEST SUCCESS: testLuaCallBlockReturnIntWith5ciqfd");
end

function testRecursiveBlock_bBlock(self, aBlock, bBlock)
	local webView = UIView:init()
	--if call a block made by toblock, you should call 
	luaCallBlockWithParamsTypeArray(aBlock, {"void","id", "id", "UIViewController *", "UIWebView *"},
		"abc", 
		toblock(
			function(code, responseData)
				print("lua code=" .. code .. " responseData=" .. tostring(responseData))
			end
		, {"void", "NSString *", "NSDictionary *"}), 
		self, 
		webView)
end

function testReturnObjectBlock(self, block)
	local res = block(TEST_VALUE_STRING, {k1="v1", k2="v2"})
	assert(res == TEST_VALUE_STRING .. TEST_VALUE_STRING, "testReturnObjectBlock failed")

	local res = luaCallBlockWithParamsTypeArray(block, {"NSString*","NSString *", "NSDictionary * "}, TEST_VALUE_STRING, {k1="v1", k2="v2"})
	assert(res == TEST_VALUE_STRING .. TEST_VALUE_STRING, "testReturnObjectBlock failed")
	print("LUA TEST SUCCESS: testReturnObjectBlock");
end

function testReturnDictObjectBlock(self, block)
	local res = luaCallBlock(block, TEST_VALUE_STRING, {k1="v1", k2="v2"})
	local res = block(TEST_VALUE_STRING, {k1="v1", k2="v2"})
	assert(res["key1"] == "value1", "testReturnDictObjectBlock failed")

	local res = luaCallBlockWithParamsTypeArray(block, {"id", "NSString *", "NSDictionary *"}, TEST_VALUE_STRING, {k1="v1", k2="v2"})
	assert(res["key1"] == "value1", "testReturnDictObjectBlock failed")
	print("LUA TEST SUCCESS: testReturnDictObjectBlock");
end

function testReturnViewControllerObjectBlock(self, block)
	local res = luaCallBlock(block, TEST_VALUE_STRING, {k1="v1", k2="v2"})
	local res = block(TEST_VALUE_STRING, {k1="v1", k2="v2"})
	assert(res:isKindOfClass(UIViewController:class()), "testReturnViewControllerObjectBlock failed")

	local res = luaCallBlockWithParamsTypeArray(block, {"id", "id", "id"}, TEST_VALUE_STRING, {k1="v1", k2="v2"})
	assert(res:isKindOfClass(UIViewController:class()), "testReturnViewControllerObjectBlock failed")
	print("LUA TEST SUCCESS: testReturnViewControllerObjectBlock");
	block = nil
end


--float
function testReturnCGFloatWithFirstCGFloatBlock(self, block)

	local res = luaCallBlock(block, TEST_VALUE_CGFLOAT, TEST_VALUE_BOOL, TEST_VALUE_INTEGER,TEST_VALUE_CGFLOAT)
	local res = block(TEST_VALUE_CGFLOAT, TEST_VALUE_BOOL, TEST_VALUE_INTEGER,TEST_VALUE_CGFLOAT)
	assert(isDoubleEqual(res, TEST_VALUE_CGFLOAT), "testReturnCGFloatWithFirstCGFloatBlock failed")
	print("res=")
	print(res)

	local res = luaCallBlockWithParamsTypeArray(block, {"CGFloat","CGFloat", "BOOL", "NSInteger", "CGFloat"}, TEST_VALUE_CGFLOAT, TEST_VALUE_BOOL, TEST_VALUE_INTEGER,TEST_VALUE_CGFLOAT)
	print("res=")
	print(res)
	assert(isDoubleEqual(res, TEST_VALUE_CGFLOAT), "testReturnCGFloatWithFirstCGFloatBlock failed")
	print("LUA TEST SUCCESS: testReturnCGFloatWithFirstCGFloatBlock");
end

--int
function testReturnIntegerWithFirstIntegerBlock(self, block)

	local res = luaCallBlock(block, TEST_VALUE_INTEGER, TEST_VALUE_BOOL,TEST_VALUE_CGFLOAT, self);
	local res = block(TEST_VALUE_INTEGER, TEST_VALUE_BOOL,TEST_VALUE_CGFLOAT, self);
	assert(res == TEST_VALUE_INTEGER, "testReturnIntegerWithFirstIntegerBlock failed")

	local res = luaCallBlockWithParamsTypeArray(block, {"NSInteger","NSInteger", "BOOL", "CGFloat", "id"}, TEST_VALUE_INTEGER, TEST_VALUE_BOOL,TEST_VALUE_CGFLOAT, self);
	assert(res == TEST_VALUE_INTEGER, "testReturnIntegerWithFirstIntegerBlock failed")
	print("LUA TEST SUCCESS: testReturnViewControllerObjectBlock");
end
