require "tests.fixtures.UberExtendedSimpleObject"

-- TEST wax.class's forwardInvocation stuff (return values)

describe["A 'Lua created' WaxClass instance (whose parent is ALSO a WaxClass)"] = function()
  before = function()
  end
  
  it["is created via a super init method"] = function()
    local o = UberExtendedSimpleObject:initWithWord("a word")
    expect(tolua(o:value())).should_be("a word")
  end
  
  it["is created via a overwritten super init method"] = function()
    local o = UberExtendedSimpleObject:initWithAnimal("elephant")
    expect(tolua(o:value())).should_be("elephant")
  end
  
  it["can override a method"] = function()
    local o = UberExtendedSimpleObject:initWithValue("original")
    expect(tolua(o:valueOverride())).should_be("NOT THE ORIGINAL")
  end
  
  it["can be called via obj-c"] = function()
    local o = UberExtendedSimpleObject:initWithValue("obj")
    result = o:performSelector("stringForTesting")
    expect(tolua(result)).should_be("Look at me!")
  end
  
  it["can be called via obj-c with args"] = function()
    local o = UberExtendedSimpleObject:initWithValue("obj")
    result = o:performSelector_withObject("stringForTestingWithArg:", "we all!")
    expect(tolua(result)).should_be("So say we all!")
  end
  
  it["can call a class method on it's super"] = function()
    local o = UberExtendedSimpleObject:helloMommy()
    expect(o).should_be("Hi Corey!")  
  end
end