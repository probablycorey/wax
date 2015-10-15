function assertResult( self,  aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
	print("lua aBOOL=" .. tostring(aBOOL) .. " aInt=" .. tostring(aInt) .. " aInteger=" .. tostring(aInteger) .. " aFloat=" .. tostring(aFloat) .. " aCGFloat=" .. tostring(aCGFloat) .. " aId=" .. tostring(aId))
	assert(aBOOL==TEST_VALUE_BOOL);assert(aInt==TEST_VALUE_INT);
	assert(aInteger==TEST_VALUE_INTEGER);assert(isDoubleEqual(aFloat, TEST_VALUE_FLOAT));
	assert(isDoubleEqual(aCGFloat, TEST_VALUE_CGFLOAT));
	assert(aId == self);
end


waxClass{"AutoTestBlockTransfer"}

function autoTestStart( self )
	self:testReturnVoidWithVoidBlock(
	toblock(
		function()
			print("LUA TEST SUCCESS: testReturnVoidWithVoidBlock")
		end
		, {"void"})
	)

	self:testReturnVoidWithFirstIntBlock(
	toblock(
		function(aFirstInt, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("aFirstInt=" .. tostring(aFirstInt))
			assert(aFirstInt == TEST_VALUE_INT, "aFirstInt不等")
			assertResult(self, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("LUA TEST SUCCESS: testReturnVoidWithFirstIntBlock")
		end
		, {"void","int", "BOOL", "int", "NSInteger", "float", "CGFloat", "id"})
	)
	self:testReturnBOOLWithFirstBOOLBlock(
	toblock(
		function(aFirstBOOL, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("aFirstBOOL=" .. tostring(aFirstBOOL))
			assert(aFirstBOOL == TEST_VALUE_BOOL)
			assertResult(self, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("LUA TEST SUCCESS: testReturnBOOLWithFirstBOOLBlock")
			return aFirstBOOL
		end
		, {"BOOL","BOOL", "BOOL", "int", "NSInteger", "float", "CGFloat", "id"})
	)
	self:testReturnIntWithFirstIntBlock(
	toblock(
		function(aFirstInt, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("aFirstInt=" .. tostring(aFirstInt))
			assert(aFirstInt == TEST_VALUE_INT, "aFirstInt不等")
			assertResult(self, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("LUA TEST SUCCESS: testReturnIntWithFirstIntBlock")
			return aFirstInt
		end
		, {"int","int", "BOOL", "int", "NSInteger", "float", "CGFloat", "id"})
	)

	self:testReturnIntegerWithFirstIntegerBlock(
	toblock(
		function(aFirstInteger, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("aFirstInteger=" .. tostring(aFirstInteger))
			assert(aFirstInteger == TEST_VALUE_INTEGER)
			assertResult(self, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("LUA TEST SUCCESS: testReturnIntegerWithFirstIntegerBlock")
			return aFirstInteger
		end
		, {"NSInteger","NSInteger", "BOOL", "int", "NSInteger", "float", "CGFloat", "id"})
	)

	self:testReturnCharPointerWithFirstCharPointerBlock(
	toblock(
		function(aFirstCharPointer, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("aFirstCharPointer=" .. tostring(aFirstPointer))
			assertResult(self, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("LUA TEST SUCCESS: testReturnCharPointerWithFirstCharPointerBlock")
			return aFirstCharPointer
		end
		, {"char *","char*", "BOOL", "int", "NSInteger", "float", "CGFloat", "id"})
	)

	self:testReturnVoidPointerWithFirstVoidPointerBlock(
	toblock(
		function(aFirstVoidPointer, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("aFirstVoidPointer=" .. tostring(aFirstVoidPointer))
			-- assert(aFirstVoidPointer == TEST_VALUE_INT, "aFirstInt不等")
			assertResult(self, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("LUA TEST SUCCESS: testReturnVoidPointerWithFirstVoidPointerBlock")
			return aFirstVoidPointer
		end
		, {"void *","void*", "BOOL", "int", "NSInteger", "float", "CGFloat", "id"})
	)

	self:testReturnIdWithFirstIdBlock(
	toblock(
		function(aFirstId, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("aFirstId=" .. tostring(aFirstId))
			-- assert(aFirstId == self, "aFirstInt不等")
			assertResult(self, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("LUA TEST SUCCESS: testReturnIdWithFirstIdBlock")
			return aFirstId
		end
		, {"id","id", "BOOL", "int", "NSInteger", "float", "CGFloat", "id"})
	)



	self:testReturnFloatWithFirstFloatBlock(
	toobjc(
		function(aFirstFloat, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("aFirstFloat=" .. tostring(aFirstFloat))
			assert(isDoubleEqual(aFirstFloat, TEST_VALUE_FLOAT));
			assertResult(self, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("LUA TEST SUCCESS: testReturnFloatWithFirstFloatBlock")
			return aFirstFloat
		end
		):luaBlockWithParamsTypeArray({"float","float", "BOOL", "int", "NSInteger", "float", "CGFloat", "id"})
	)
	self:testReturnCGFloatWithFirstCGFloatBlock(
	toobjc(
		function(aFirstCGFloat, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("aFirstCGFloat=" .. tostring(aFirstCGFloat))
			assert(isDoubleEqual(aFirstCGFloat, TEST_VALUE_CGFLOAT));
			assertResult(self, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("LUA TEST SUCCESS: testReturnCGFloatWithFirstCGFloatBlock")
			return aFirstCGFloat
		end
		):luaBlockWithParamsTypeArray({"CGFloat","CGFloat", "BOOL", "int", "NSInteger", "float", "CGFloat", "id"})
	)
	self:testReturnDoubleWithFirstDoubleBlock(
	toobjc(
		function(aFirstDouble, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("aFirstDouble=" .. tostring(aFirstDouble))
			assert(isDoubleEqual(aFirstDouble, TEST_VALUE_DOUBLE));
			assertResult(self, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
			print("LUA TEST SUCCESS: testReturnDoubleWithFirstDoubleBlock")
			return aFirstDouble
		end
		):luaBlockWithParamsTypeArray({"double","double", "BOOL", "int", "NSInteger", "float", "CGFloat", "id"})
	)
end