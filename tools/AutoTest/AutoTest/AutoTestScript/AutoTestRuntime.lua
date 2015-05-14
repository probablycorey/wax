waxClass{"AutoTestRuntime"}

function autoTestStart(self)
	print("begin AutoTestRuntime autoTestStart")
	
	local res = objc_getAssociatedObject(self, self:getKey1())
	print('res=', res)

	objc_setAssociatedObject(self, self:getKey1(), "lua_value1", 1)
	local res = objc_getAssociatedObject(self, self:getKey1())
	print('res=', res)

	objc_removeAssociatedObjects(self)
	local res = objc_getAssociatedObject(self, self:getKey1())
	print('res=', res)


	print('class_getName=', class_getName(self:class()))
	print('class_getSuperclass=', class_getSuperclass(self:class()))
	print('class_isMetaClass=', class_isMetaClass(self:class()))
	print('class_getInstanceSize=', class_getInstanceSize(self:class()))
	print('class_getInstanceVariable=', class_getInstanceVariable(self:class(), "view"))
	print('class_getClassVariable=', class_getClassVariable(self:class(), "view"))

	print("end AutoTestRuntime autoTestStart")
end