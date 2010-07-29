require "tests.fixtures.ProtocolSimpleObject"

describe["An ObjClass with delegate"] = function()
  before = function()
    delegateObject = ProtocolSimpleObject:init()
    object = wax.class["SimpleDelegateObject"]:init()
    object:setDelegate(delegateObject)
  end
  
  it["responds to protocol selectors"] = function()    
    expect(delegateObject:respondsToSelector("requiredMethod")).should_be(true)
    expect(delegateObject:respondsToSelector("requiredMethodWithArg:")).should_be(true)
    expect(delegateObject:respondsToSelector("optionalMethod")).should_be(true)
    expect(delegateObject:respondsToSelector("optionalMethodWithArg:")).should_be(true)
  end
  
  it["returns required methods"] = function()        
    expect(tolua(object:callRequiredMethod())).should_be(1)
  end
  
  it["returns required method with arg"] = function()        
    expect(tolua(object:callRequiredMethodWithArg(1))).should_be(2)
  end
  
  it["returns optional method"] = function()        
    expect(tolua(object:callOptionalMethod(2))).should_be(2)
  end
  
  it["returns optional method with arg"] = function()        
    expect(tolua(object:callOptionalMethodWithArg(2))).should_be(4)
  end
end