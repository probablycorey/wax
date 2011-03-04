
describe["Base64 decoding"] = function()

  it["should pass ASCII NULs"] = function()
    local ans = wax.base64.decode("AAA=")
    expect(#ans).should_be(2)
    expect(string.byte(ans, 1)).should_be(0)
    expect(string.byte(ans, 2)).should_be(0)
  end

end
