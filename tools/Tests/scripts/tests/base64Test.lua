
describe["Base64 encoding"] = function()
  
  it["should be able to round trip tricky combinations of two bytes"] = function()
    for a = 0,255 do
      for _,b in ipairs({0,1,2,252,253,254}) do
        local s = string.char(a)..string.char(b)
        expect(wax.base64.decode(wax.base64.encode(s))).should_be(s)
      end
    end
  end

  it["should get the same results as tclsh's base64"] = function()
    local data = string.char(unpack({
      0,16,131,16,81,135,32,146,139,48,211,143,65,20,147,81,
      85,151,97,150,155,113,215,159,130,24,163,146,89,167,162,154,
      171,178,219,175,195,28,179,211,93,183,227,158,187,243,223,191
    }))
    expect(wax.base64.encode(data)).should_be("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")
  end
  
end

describe["Base64 decoding"] = function()

  it["should pass ASCII NULs"] = function()
    local ans = wax.base64.decode("AAA=")
    expect(#ans).should_be(2)
    expect(string.byte(ans, 1)).should_be(0)
    expect(string.byte(ans, 2)).should_be(0)
  end

  it["should get the same results as tclsh's base64"] = function()
    local data = string.char(unpack({
      0,16,131,16,81,135,32,146,139,48,211,143,65,20,147,81,
      85,151,97,150,155,113,215,159,130,24,163,146,89,167,162,154,
      171,178,219,175,195,28,179,211,93,183,227,158,187,243,223,191
    }))
    expect(wax.base64.decode("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")).should_be(data)
  end

end
