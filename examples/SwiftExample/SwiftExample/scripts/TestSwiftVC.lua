luaSetWaxConfig({openBindOCFunction="true"})

waxClass{"SwiftExample.TestSwiftVC"}

function viewDidLoad(self)
	print("lua viewDidLoad");
	self:ORIGviewDidLoad();
	--调类方法
	objc_getClass("SwiftExample.TestSwiftVC"):testClassReturnVoidWithaId(self:view())
end

--hook实例方法
function tableView_didSelectRowAtIndexPath(self, tableView, indexPath)
	print("lua tableView_didSelectRowAtIndexPath")
	--创建Swift对象
	local vc = objc_getClass("SwiftExample.TestBSwiftVC"):initWithNibName_bundle("TestBSwiftVC", nil);
    self:navigationController():pushViewController_animated(vc, true);
end

--hook类方法
function testClassReturnVoidWithaBool_aInteger_aFloat_aDouble_aString_aObject(self, aBool, aInteger,aFloat,aDouble,aString,aObject)
	print("testClassReturnVoidWithaBool_aInteger_aFloat_aDouble_aString_aObject")
	self:ORIGtestClassReturnVoidWithaBool_aInteger_aFloat_aDouble_aString_aObject(aBool, aInteger,aFloat,aDouble,aString,aObject)
end

waxClass{"SwiftExample.TestASwiftClass"}

function testReturnVoidWithaId(self, aId)	
	print("lua testReturnVoidWithaId")
	print(aId)
	self:ORIGtestReturnVoidWithaId(aId)
end

function testNoExistMethod(self)
	print("testNoExistMethod")
end



waxClass{"SwiftExample.TestBSwiftVC"}

function testOCVCBUttonPressed(self, sender)	
	print("lua testOCVCBUttonPressed")
	local vc = TestOCVC:init()
    self:navigationController():pushViewController_animated(vc, true);
end

waxClass{"TestOCVC"}

function viewDidLoad(self)	
	print("lua viewDidLoad")
	self:ORIGviewDidLoad()
end