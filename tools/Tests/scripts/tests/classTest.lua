require "tests.fixtures.ExtendedSimpleObject"
require "tests.fixtures.Deer"
require "tests.fixtures.Bambi"

describe["A WaxClass instance with an ObjC Super"] = function()
  before = function()
  end
  
  it["is created via method"] = function()
    local o = ExtendedSimpleObject:initWithAnimal("elephant")
    expect(o:value()).should_be("elephant")
  end
  
  it["is created via a overridden super init method"] = function()
    local o = ExtendedSimpleObject:initWithValue("a value")
    expect(o:value()).should_be("a value")
  end
  
  it["is created via a super init method"] = function()
    local o = ExtendedSimpleObject:initWithWord("a word")
    expect(o:value()).should_be("a word")
  end
  
  it["is created via a plain init method"] = function()
    local o = ExtendedSimpleObject:init()
    expect(o).should_exist()
  end
  
  it["can override a method"] = function()
    local o = ExtendedSimpleObject:initWithValue("original")
    expect(o:valueOverride()).should_be("NOT THE ORIGINAL")
  end
  
  it["can be called via obj-c"] = function()
    local o = ExtendedSimpleObject:initWithValue("obj")
    result = o:performSelector("stringForTesting")
    expect(result).should_be("Look at me!")
  end
  
  it["can be called via obj-c with args"] = function()
    local o = ExtendedSimpleObject:initWithValue("obj")
    result = o:performSelector_withObject("stringForTestingWithArg:", "we all!")
    expect(result).should_be("So say we all!")
  end
end

describe["A WaxClass instance with an WaxClass Super"] = function()
  before = function()
  end
  
  it["is created via method"] = function()
    local o = Bambi:initWithAge(12)
    expect(o:getAge()).should_be(12)
  end
  
  it["is created via an init method"] = function()
    local o = Bambi:initWithName("Bammmmbi")
    expect(o:getName()).should_be("Bammmmbi")
  end
  
  it["is created via an overridden init method"] = function()
    local one = Bambi:initWithFood("Beef")
    local two = Bambi:initWithFood("Grass")
    expect(one:getFood()).should_be("Beef")
    expect(one.bambiFood).should_be("BambiBeef")
    expect(one.deerFood).should_be("DeerBeef")
    
    expect(two:getFood()).should_be("Grass")
    expect(two.bambiFood).should_be("BambiGrass")
    expect(two.deerFood).should_be("DeerGrass")
  end
  
  it["can call a super method"] = function()
    local o = Bambi:initWithAge(10)
    expect(o:doubleAge()).should_be(20)
  end
  
  it["can call an overridden method"] = function()
    local o = Bambi:initWithAge(1)
    expect(o:tripleAge()).should_be(3)
  end
  
  it["can call an overridden method that sets a lua varible on instance"] = function()
    local one = Bambi:initWithAge(1)
    local two = Bambi:initWithAge(2)
    one:setDeath("gun")
    two:setDeath("fire")
    expect(one.death).should_be("gun")
    expect(two.death).should_be("fire")
  end
  
  it["can call a super method that takes a function as a arg"] = function()
    local o = Bambi:initWithAge(10)
    o:doSomethingToAge(function(a) return a * 5 end)
    expect(o:getAge()).should_be(50)
  end
  
  it["can call a super method that is also defined in the current class"] = function()
    local o = Bambi:initWithAge(10)
    local name = o:getInfo()
    expect(name).should_be("DeerClass:BambiClass")
  end
  
  it["can call a super method that is also defined in the current class, and also an NSObject method"] = function()
    local o = Bambi:initWithAge(10)
    local hash = o:hash()
    expect(hash).should_be("100:10")
  end
  
  it["can call super method with multiple args"] = function()
    local o = Bambi:initWithAge(10)
    local a,b,c = o:returnsWhatYouSendIn(1,2,3)
    expect(a).should_be(1)
    expect(b).should_be(2)
    expect(c).should_be(3)
  end
  
  it["has access to instance variable from a super method call"] = function()
    local o = Bambi:initWithAge(10)
    expect(o:getAgeFromSuper()).should_be(10)
  end
  
  it["checks if a method exists on the instance before the super"] = function()
    local o = Bambi:init()
    expect(o:callgetClassNameFromSuper()).should_be("BambiClass")
  end
  
  it["checks super for method if super is called directly"] = function()
    local o = Bambi:initWithFood("grass")
    expect(o.super:hash()).should_be(100)
  end
end

describe["A WaxClass with an WaxClass Super"] = function()
  before = function()
  end
  
  it["can call method defined in it's superclass"] = function()
    local result = Bambi:aClassMethod()
    expect(result).should_be("yes")
  end
  
  it["can call super via a class method"] = function()
    local result = Bambi:isEqual(Bambi)
    expect(result).should_be(true)
    
    result = Bambi:isEqual(NSString)
    expect(result).should_be(false)
  end
  
  it["can call super method with multiple args"] = function()
    local a, b, c = Bambi:returnsWhatYouSendIn(1,2,3)
    expect(a).should_be(1)
    expect(b).should_be(2)
    expect(c).should_be(3)
  end
end
