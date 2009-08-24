describe["Unpacking structs"] = function()
  before = function()
    Structs = oink.class["Structs"]
  end
  
  it["can upack a single value struct"] = function()
    local struct = oink.struct.unpack(Structs:numberFive())
    expect( #struct ).should_be(1)
    expect( struct[1] ).should_be(5)
  end
  
  it["can upack a multivalue struct"] = function()
    local struct = oink.struct.unpack(Structs:rangeTwoTwenty())
    expect( #struct ).should_be(2)
    expect( struct[1] ).should_be(2)
    expect( struct[2] ).should_be(20)
  end
end

describe["Packing structs"] = function()
  before = function()
    Structs = oink.class["Structs"]
  end
  
  it["can pack a single value struct"] = function()
    local struct = oink.struct.pack("i", 6)
    expect( Structs:expectSix(struct) ).should_be(true)
  end
  
  it["can pack a multivalue struct"] = function()
    local struct = oink.struct.pack("ffff", 1, 2, 3, 4)
    expect( Structs:expectsCGRectOneTwoThreeFour(struct) ).should_be(true)
  end
  
  it["creates an error when there are not enough arguments to fill the struct"] = function()
    expect( function() oink.struct.pack("ffff", 1, 2, 3) end ).should_error()    
  end
  
  it["creates an error when there are too many arguments to fill the struct"] = function()
    expect( function() oink.struct.pack("ffff", 1, 2, 3, 4, 5) end ).should_error()    
  end
end

describe["Creating custom structs"] = function()
  before = function()
    Structs = oink.class["Structs"]
  end

  it["can be created"] = function()
    oink.struct.create("CustomStruct", "dd", "x", "y")
    expect( type(CustomStruct) ).should_be("function")
    expect( CustomStruct(10, 20) ).should_exist()
  end
  
  it["is read by obj-c correctly"] = function()
    oink.struct.create("CustomStruct", "dd", "x", "y")
    expect( Structs:expectsCustomStructFiftySixty(CustomStruct(50,60)) ).should_be(true)
  end
end

describe["Reading custom structs"] = function()
  before = function()
    Structs = oink.class["Structs"]
    oink.struct.create("CustomStruct", "dd", "x", "y")
  end

  it["can access values by name"] = function()
    result = CustomStruct(10, 20.2)
    expect( result.x ).should_be(10)
    expect( result.y ).should_be(20.2)
  end
  
  it["can access values via obj-c by name"] = function()
    result = Structs:seventyPointFiveEighty()
    expect( result.x ).should_be(70.5)
    expect( result.y ).should_be(80)
  end
end

describe["Writing custom structs"] = function()
  before = function()
    Structs = oink.class["Structs"]
  end

  -- it["can set value from lua"] = function()
  --   oink.struct.create("CustomStruct", "dd", "x", "y")(10, 20)
  --   expect( CustomStruct.x ).should_be(10)
  --   result.x = 50
  --   expect( CustomStruct.x ).should_be(50)
  -- end  
end
