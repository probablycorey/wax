describe["Objlua Instance"] = function()
  before = function()
    testString = toobjc(NS.String:initWithString("12345"))
  end

  it["exists!"] = function()
    expect(testString).should_exist()
  end
  
  it["knows about it's class"] = function()
    expect(testString).should_be_kind_of(NS.String)
  end

  it["responds to method with no args"] = function()
    expect(testString:length()).should_be(5)
  end

  it["responds to method with args"] = function()
    expect(testString:hasPrefix("12")).should_be(true)
  end
end