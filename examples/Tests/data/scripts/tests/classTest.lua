require "tests.fixtures.ExtendedSimpleObject"

-- TEST wax.class's forwardInvocation stuff (return values)

describe["A 'Lua created' ObjClass instance"] = function()
  before = function()
  end
  
  it["is created via super call of different name"] = function()
    local o = ExtendedSimpleObject:initWithAnimal("elephant")
    expect(tolua(o:value())).should_be("elephant")  
  end
  
  it["is created via super call of same name"] = function()
    local o = ExtendedSimpleObject:initWithValue("a value")
    expect(tolua(o:value())).should_be("a value")
  end
  
  it["can override a method"] = function()
    local o = ExtendedSimpleObject:initWithValue("original")
    expect(tolua(o:valueOverride())).should_be("NOT THE ORIGINAL")
  end
  
  it["can be called via obj-c"] = function()
    local o = ExtendedSimpleObject:initWithValue("obj")
    result = o:performSelector("stringForTesting")
    expect(tolua(result)).should_be("Look at me!")
  end
  
  it["can be called via obj-c with args"] = function()
    local o = ExtendedSimpleObject:initWithValue("obj")
    result = o:performSelector_withObject("stringForTestingWithArg:", "we all!")
    expect(tolua(result)).should_be("So say we all!")
  end
end

describe["A 'Lua created' ObjClass"] = function()
  before = function()
  end
  
  it["can call a class method on it's super"] = function()
    local o = ExtendedSimpleObject:helloMommy()
    expect(o).should_be("Hi Corey!")  
  end
end