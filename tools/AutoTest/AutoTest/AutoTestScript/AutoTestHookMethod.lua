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

--------test add method
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


-- hook class method 

function testHookClassaId(self, aId)
    print("aId=" .. tostring(aId));
    print("LUA TEST SUCCESS: testHookClassaId")
    self:ORIGtestHookClassaId(aId);
end

function testHookClassReturnIdWithaId(self, aId)
   	print("aId=" .. tostring(aId));
    print("LUA TEST SUCCESS: testHookClassReturnIdWithaId")
    return self:ORIGtestHookClassReturnIdWithaId(aId)
end


-- test underline prefix method
function UNDERxLINE(self)
	print("lua _ 1")
	print(self:ORIGUNDERxLINE())
	print("lua _ 2")
end

function UNDERxLINEprefixMethod(self, str)
	print("lua _prefixMethod1")
	self:ORIGUNDERxLINEprefixMethod(TEST_VALUE_STRING)
    print("lua _prefixMethod2")
end

function UNDERxLINEprefixMethodA_B(self, str, b)
   	print("lua _prefixMethodA_B 1")
	print(self:ORIGUNDERxLINEprefixMethodA_B(TEST_VALUE_STRING, TEST_VALUE_STRING))
    print("lua _prefixMethodA_B 2") 
end

function UNDERxLINEprefixA_UNDERxLINEb(self, a, b)
	self:ORIGUNDERxLINEprefixA_UNDERxLINEb(TEST_VALUE_STRING, TEST_VALUE_STRING)
end

function UNDERxLINEUNDERxLINEaaUNDERxLINEbbUNDERxLINE_UNDERxLINEccUNDERxLINEUNDERxLINEddUNDERxLINE_UNDERxLINEUNDERxLINEUNDERxLINEeeUNDERxLINEUNDERxLINEUNDERxLINEfUNDERxLINEUNDERxLINEUNDERxLINE(self, v1, v2, v3)
	   	print("lua __aa_bb_:(NSString *)v1 _cc__dd_:(NSString *)v2 ___ee___f___:(NSString *)v3{ 1")
	print(self:ORIGUNDERxLINEUNDERxLINEaaUNDERxLINEbbUNDERxLINE_UNDERxLINEccUNDERxLINEUNDERxLINEddUNDERxLINE_UNDERxLINEUNDERxLINEUNDERxLINEeeUNDERxLINEUNDERxLINEUNDERxLINEfUNDERxLINEUNDERxLINEUNDERxLINE(TEST_VALUE_STRING, TEST_VALUE_STRING, TEST_VALUE_STRING))
    print("lua __aa_bb_:(NSString *)v1 _cc__dd_:(NSString *)v2 ___ee___f___:(NSString *)v3{ 2") 
end

function UNDERxLINEUNDERxLINEUNDERxLINEaaUNDERxLINEbbUNDERxLINE_UNDERxLINEccUNDERxLINEUNDERxLINEddUNDERxLINE_UNDERxLINEUNDERxLINEUNDERxLINEeeUNDERxLINEUNDERxLINEUNDERxLINEfUNDERxLINEUNDERxLINEUNDERxLINE(self, v1, v2, v3)
	   	print("lua ___aa_bb_:(NSString *)v1 _cc__dd_:(NSString *)v2 ___ee___f___:(NSString *)v3{ 1")
	print(self:ORIGUNDERxLINEUNDERxLINEUNDERxLINEaaUNDERxLINEbbUNDERxLINE_UNDERxLINEccUNDERxLINEUNDERxLINEddUNDERxLINE_UNDERxLINEUNDERxLINEUNDERxLINEeeUNDERxLINEUNDERxLINEUNDERxLINEfUNDERxLINEUNDERxLINEUNDERxLINE(TEST_VALUE_STRING, TEST_VALUE_STRING, TEST_VALUE_STRING))
    print("lua ___aa_bb_:(NSString *)v1 _cc__dd_:(NSString *)v2 ___ee___f___:(NSString *)v3{ 2") 
end

--- struct method

function initWithFrame(self, aCGRect)
    print("aCGRect=" .. tostring(aCGRect));
    self = self.super:init();
    return self
end

function testReturnCGRectWithCGRect(self, aCGRect)
    local rect = CGRect(aCGRect.x+10, aCGRect.y+20, aCGRect.width+30, aCGRect.height+40);
    local origRet = self:ORIGtestReturnCGRectWithCGRect(rect)
    return origRet
end

function testReturnCGRectWithaId_aCGRect(self, aId, aCGRect)
    local rect = CGRect(aCGRect.x+10, aCGRect.y+20, aCGRect.width+30, aCGRect.height+40);
    local origRet = self:ORIGtestReturnCGRectWithaId_aCGRect(aId, rect)
    return origRet
end

function  testReturnCGSizeWithCGSize(self, aCGSize)
	local size = CGSize(aCGSize.width+10, aCGSize.height+20);
    return self:ORIGtestReturnCGSizeWithCGSize(size)
end

function testReturnCGPointWithCGPoint(self, aCGPoint)
	local point = CGPoint(aCGPoint.x+10, aCGPoint.y+20);
	return self:ORIGtestReturnCGPointWithCGPoint(point);
end

function testReturnCGFloatWithaPoint_bPoint(self, aPoint, bPoint)
	aPoint.x = aPoint.x+10
	aPoint.y = aPoint.y+20
	bPoint.x = bPoint.x+10
	bPoint.y = bPoint.y+20
	return self:ORIGtestReturnCGFloatWithaPoint_bPoint(aPoint, bPoint)
end

function testReturnNSRangeWithNSRange(self, aNSRange)
	local range = NSRange(aNSRange.location+10, aNSRange.length+20);
	return self:ORIGtestReturnNSRangeWithNSRange(range);
end

function testReturnNSRangeWithaId_aNSRange(self, aId, aNSRange)
	local range = NSRange(aNSRange.location+10, aNSRange.length+20);
	return self:ORIGtestReturnNSRangeWithaId_aNSRange(aId, range);
end
---super method

function testSuperMethodReturnId(self)
	local aId = self.super:testSuperMethodReturnId()
	assert(aId == TEST_VALUE_STRING);
	print("LUA TEST SUCCESS: testSuperMethodReturnId")
	return self
end

-- test dollar method 

function DOLLARxMARKtestDolorMethod( self )
	print("lua $testDolorMethod")
	self:ORIGDOLLARxMARKtestDolorMethod()
	return TEST_VALUE_STRING
end

function DOLLARxMARKtestDolorClassMethod( self )
	print("lua $testDolorClassMethod")
	self:ORIGDOLLARxMARKtestDolorClassMethod()
	return TEST_VALUE_STRING
end

function UNDERxLINEDOLLARxMARKtestDOLLARxMARKDolorUNDERxLINEMethod_UNDERxLINEbDOLLARxMARK(self, v1, v2)
	print("lua _$test$Dolor_Method:_b$:")
	local res = self:ORIGUNDERxLINEDOLLARxMARKtestDOLLARxMARKDolorUNDERxLINEMethod_UNDERxLINEbDOLLARxMARK(v1, v2)
	res = res .. TEST_VALUE_STRING
	return res
end

