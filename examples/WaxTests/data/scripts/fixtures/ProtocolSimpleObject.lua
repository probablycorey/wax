waxClass{"ProtocolSimpleObject", "SimpleObject", protocols = {"SimpleProtocol"}}

function requiredMethod()
  return 1
end

function requiredMethodWithArg(self, number)
  return tolua(number) + 1
end

-- @optional

function optionalMethod()
  return 2
end

function optionalMethodWithArg(self, number)
  return tolua(number) + 2
end
