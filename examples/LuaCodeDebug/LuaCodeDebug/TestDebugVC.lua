require('mobdebug').start()

waxClass{"TestDebugVC"}

function viewDidLoad(self)
	self:ORIGviewDidLoad();
	print(self:memberString())
	print(self:memberDict())
  self:setMemberString("123")
  self:setMemberDict({key1="value1", key2="value2"})
end

function aButtonPress(self, sender)
	print("lua aButtonPress")
	print(sender)
	self:aAction(self:memberString())
end

function aAction(self, a)
	print("lua aAction")
	print(a)
	self:bAction(self:memberDict())
end

function bAction(self, b)
	print("lua aAction")
	print(b)
	for k, v in pairs(b) do
		print("k=", k, " v=", v)
	end
	self:cAction("test")
end

function cAction(self, c)
	print("lua cAction")
end