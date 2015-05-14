waxClass{"AutoTestHookMethod"}


function testHookReturnVoid( self)
	print("LUA TEST SUCCESS: testHookaId");
	self:ORIGtestHookReturnVoid()
end

function testHookReturnId( self)
	print("LUA TEST SUCCESS: testHookaId");
	self:ORIGtestHookReturnId()
	return self
end


function testHookaId( self, aId )
	assert(aId == self);
	print("LUA TEST SUCCESS: testHookaId");
	self:ORIGtestHookaId(aId);
	--UIAlertView:initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("hotpatch", "test", nil, "ok", nil):show()
	return aId
end

function testHookaInt( self, aInt )
print("aInt=", aInt)
	assert(aInt == TEST_VALUE_INT);

	print("LUA TEST SUCCESS: testHookaInt");
	self:ORIGtestHookaInt(aInt);
	return aInt
end

function testHookaLongLong( self, aLongLong )
	assert(aLongLong == TEST_VALUE_LONG_LONG);
	print("LUA TEST SUCCESS: testHookaInt");
	self:ORIGtestHookaLongLong(aLongLong);
	return aLongLong
end



function testHookaBOOL( self, aBOOL )
	print('aBOOL=' .. tostring(aBOOL))
	print('TEST_VALUE_BOOL' .. tostring(TEST_VALUE_BOOL))
	assert(aBOOL == TEST_VALUE_BOOL);
	print("LUA TEST SUCCESS: testHookaBOOL");
	self:ORIGtestHookaBOOL(aBOOL);
	return aBOOL
end

function testHookaFloat( self, aFloat )
	assert(isDoubleEqual(aFloat, TEST_VALUE_FLOAT));
	print("LUA TEST SUCCESS: testHookaFloat");
	self:ORIGtestHookaFloat(aFloat);
	return aFloat
end

function testHookaDouble( self, aDouble )
	assert(isDoubleEqual(aDouble, TEST_VALUE_DOUBLE));
	print("LUA TEST SUCCESS: testHookaDouble");
	self:ORIGtestHookaDouble(aDouble);
	return aDouble
end

function testHookaInteger_bId_cId_dId( self, aInteger, bId, cId, dId)
	assert(aInteger == TEST_VALUE_INTEGER);
	assert(bId:isKindOfClass(UIViewController:class()))
	assert(cId:isKindOfClass(UIView:class()))
	assert(dId:isKindOfClass(UILabel:class()))

	print("LUA TEST SUCCESS: testHookaInteger_bId_cId_dId");
	self:ORIGtestHookaInteger_bId_cId_dId( aInteger, bId, cId, dId)
	return aInteger
end


function testHookaChar_aInteger_aBOOL_aDouble_aString_aId(self, aChar, aInteger, aBOOL, aDouble, aString, aId)
	assert(aChar==97); assert(aInteger==TEST_VALUE_INTEGER);
	assert(aBOOL==true); assert(isDoubleEqual(aDouble, 12345.6789));
	 assert(aString=="hij"); assert(aId == self);

	print("LUA TEST SUCCESS: testHookaChar_aInteger_aBOOL_aDouble_aString_aId")
	self:ORIGtestHookaChar_aInteger_aBOOL_aDouble_aString_aId(aChar, aInteger, aBOOL, aDouble, aString, aId)
	return aChar
end

--------测试新增方法
function testAddMethodWithVoid(self)
 	print("LUA TEST SUCCESS: testAddMethod")
end

function testAddMethodWithaId(self, aId)
	print("aId=" .. tostring(aId))
	print("LUA TEST SUCCESS: testAddMethodWithaId")
    return aId;
end

function testAddMethodWithaId_bId_cId_dId_eId(self, aId, bId, cId, dId, eid)
	print("aId=" .. tostring(aId))
	print("LUA TEST SUCCESS: testAddMethodWithaId_bId_cId_dId_eId")
    return aId;
end
