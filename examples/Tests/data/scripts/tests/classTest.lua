require "tests.fixtures.ExtendedSimpleObject"
require "tests.fixtures.Deer"
require "tests.fixtures.Bambi"

describe["A WaxClass instance with an ObjC Super"] = function()
  before = function()
  end
  
  it["is created via method"] = function()
    local o = ExtendedSimpleObject:initWithAnimal("elephant")
    expect(tolua(o:value())).should_be("elephant")
  end
  
  it["is created via a overwritten super init method"] = function()
    local o = ExtendedSimpleObject:initWithValue("a value")
    expect(tolua(o:value())).should_be("a value")
  end
  
  it["is created via a super init method"] = function()
    local o = ExtendedSimpleObject:initWithWord("a word")
    expect(tolua(o:value())).should_be("a word")
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

describe["A WaxClass instance with an WaxClass Super"] = function()
  before = function()
  end
  
  it["is created via method"] = function()
    local o = Bambi:initWithAge(12)
    expect(tolua(o:getAge())).should_be(12)
  end
  
  it["is created via an init method"] = function()
    local o = Bambi:initWithName("Bammmmbi")
    expect(tolua(o:getName())).should_be("Bammmmbi")
  end

  it["is created via an overwritten init method"] = function()
    local o = Bambi:initWithFood("Beef")
    expect(tolua(o:getFood())).should_be("Beef")
  end
  
  it["can call a super method"] = function()
    local o = Bambi:initWithAge(10)
    expect(o:doubleAge()).should_be(20)
  end
  
  it["can call an overwritten method"] = function()
    local o = Bambi:initWithAge(1)
    expect(o:tripleAge()).should_be(3)
  end
end

describe["A WaxClass with an WaxClass Super"] = function()
  before = function()
  end
  
  it["can call a super method on a class"] = function()
    local result = Bambi:aClassMethod()
    expect(result).should_be("yes")
  end
end
