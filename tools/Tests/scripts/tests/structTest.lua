describe["Unpacking structs"] = function()
  before = function()
    Structs = wax.class["Structs"]
  end
  
  it["can upack a single value struct"] = function()
    local struct = wax.struct.unpack(Structs:numberFive())
    expect( #struct ).should_be(1)
    expect( struct[1] ).should_be(5)
  end
  
  it["can upack a multivalue struct"] = function()
    local struct = wax.struct.unpack(Structs:rangeTwoTwenty())
    expect( #struct ).should_be(2)
    expect( struct[1] ).should_be(2)
    expect( struct[2] ).should_be(20)
  end
end

describe["Packing structs"] = function()
  before = function()
    Structs = wax.class["Structs"]
  end
  
  it["can pack a single value struct"] = function()
    local struct = wax.struct.pack("i", 6)
    expect( Structs:expectSix(struct) ).should_be(true)
  end
  
  it["can pack a multivalue struct"] = function()
    local struct = wax.struct.pack("ffff", 1, 2, 3, 4)
    expect( Structs:expectsCGRectOneTwoThreeFour(struct) ).should_be(true)
  end
  
  it["creates an error when there are not enough arguments to fill the struct"] = function()
    expect( function() wax.struct.pack("ffff", 1, 2, 3) end ).should_error()    
  end
  
  it["creates an error when there are too many arguments to fill the struct"] = function()
    expect( function() wax.struct.pack("ffff", 1, 2, 3, 4, 5) end ).should_error()    
  end
end

describe["Creating structs"] = function()
  before = function()
    Structs = wax.class["Structs"]
  end

  it["can be created"] = function()
    wax.struct.create("CustomStruct", "dd", "x", "y")
    expect( type(CustomStruct) ).should_be("function")
    expect( CustomStruct(10, 20) ).should_exist()
  end
  
  it["is read by obj-c correctly"] = function()
    wax.struct.create("CustomStruct", "dd", "x", "y")
    expect( Structs:expectsCustomStructFiftySixty(CustomStruct(50,60)) ).should_be(true)
  end

  it["reads existing structs by obj-c correctly"] = function()
    wax.struct.create("CGRect", "ffff", "x", "y", "width", "height")
    expect( Structs:expectsCGRectTwoFourSixEight(CGRect(2,4,6,8)) ).should_be(true)
  end
end

describe["Reading custom structs"] = function()
  before = function()
    Structs = wax.class["Structs"]
    wax.struct.create("CustomStruct", "dd", "x", "y")
  end

  it["can access values by name"] = function()
    local result = CustomStruct(10, 20.2)
    expect( result.x ).should_be(10)
    expect( result.y ).should_be(20.2)
  end
  
  it["can access struct via obj-c by name"] = function()
    local result = Structs:seventyPointFiveEighty()
    expect( result.x ).should_be(70.5)
    expect( result.y ).should_be(80)
  end
  
  it["can access existing structs by name"] = function()
    wax.struct.create("CGRect", "ffff", "x", "y", "width", "height")
    local result = CGRect(2,4,6,8)
    expect( result.x ).should_be(2)
    expect( result.y ).should_be(4)
    expect( result.width ).should_be(6)
    expect( result.height ).should_be(8)    
  end
end

describe["Writing custom structs"] = function()
  before = function()
    Structs = wax.class["Structs"]
    wax.struct.create("CustomStruct", "dd", "x", "y")    
  end

  it["can set value from lua"] = function()
    local struct = CustomStruct(10, 20)
    struct.x = 30.3
    struct.y = 40.9
    expect( struct.x ).should_be(30.3)
    expect( struct.y ).should_be(40.9)
  end
end