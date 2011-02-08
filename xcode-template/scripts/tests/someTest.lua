describe["Some Test"] = function()
  it["can test!"] = function()
    expect(1).should_be(1)
    expect(1).should_not_be(2)
    expect("hi mystery person123").should_match("person%d+")
    expect(string.match).should_exist()
    expect(string.crazy).should_not_exist()

    local func = function() empty.nothing() end
    expect(func).should_error()
  end
end
