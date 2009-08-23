Mock = { calls = {}, return_values = {} }

-- we store all calls and requested return values indexed
-- by the mock object, we don't want to hold onto references
-- when they should be garbage collected to make the tables
-- be weak
setmetatable(Mock.calls, { __mode="k" })
setmetatable(Mock.return_values, { __mode="k" })

function Mock.__call(mock, ...)
	Mock.calls[mock] = Mock.calls[mock] or {}
	local calls = Mock.calls[mock]
	calls[#calls+1] = {...}
	
	local return_values = Mock.return_values[mock]
	
	if return_values and return_values[#calls] then	
		return unpack(return_values[#calls])
	end
end

function Mock.__index(mock, key)
	local new_mock = Mock:new()
	rawset(mock, key, new_mock)
	return new_mock
end

function Mock:new()
	local mock = { returns = self.returns, then_returns = self.returns }
	setmetatable(mock, self)
	return mock
end

function Mock:returns(...)
	if getmetatable(self) ~= Mock then
		error("returns must be called with : operator", 2)
	end
	local return_values = Mock.return_values[self] or {}
	return_values[#return_values+1] = {...}
	Mock.return_values[self] = return_values
	return self
end

matchers = matchers or {}

function matchers.was_called(target, value)
	if getmetatable(target) ~= Mock then
		return false, "target must be a Mock"
	end
	
	local calls = Mock.calls[target] or {}
	
	if #calls ~= value then
		return false, "expecting "..tostring(value).." calls, actually "..#calls
	end
	return true
end

function matchers.was_called_with(target, ...)
	if getmetatable(target) ~= Mock then
		return false, "target must be a Mock"
	end
	
	local calls = Mock.calls[target] or {}
	
	if #calls ~= 1 then
		return false, "expecting "..tostring(1).." call, actually "..#calls 
	end
	
	local params = calls[1] or {}
	
	local args = {...}
	
	if #args ~= #params then
		return false, "expecting "..#args.." parameters, actually "..#params
	end
	
	for i=1,#args do
		if args[i] ~= params[i] then
			return false, "expecting parameter #"..tostring(i).." to be "..tostring(args[i]).." actually "..tostring(params[i])
		end
	end
	return true
end