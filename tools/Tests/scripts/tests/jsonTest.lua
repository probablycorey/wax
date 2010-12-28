describe["JSON parsing"] = function()
  it["can parse numbers"] = function()
    expect(wax.json.parse("123")).should_be(123)
  end

  it["can parse nulls"] = function()
    expect(wax.json.parse("null")).should_be(nil)
  end

  it["can parse floats"] = function()
    expect(wax.json.parse("1.23")).should_be(1.23)
  end

  it["can parse booleans"] = function()
    expect(wax.json.parse("true")).should_be(true)
    expect(wax.json.parse("false")).should_be(false)
  end

  it["can parse strings"] = function()
    expect(wax.json.parse('"hello world"')).should_be("hello world")
    expect(wax.json.parse([["hello\nworld"]])).should_be("hello\nworld")
  end

  it["can parse an empty string"] = function()
    local result = wax.json.parse("")
    expect(result).should_be(nil)
  end

  it["can parse empty arrays"] = function()
    local ary = wax.json.parse("[]")
    expect(type(ary)).should_be('table')
    expect(#ary).should_be(0)
  end

  it["can parse empty hashes"] = function()
    local hash = wax.json.parse("{}")
    expect(type(hash)).should_be('table')
    expect(#hash).should_be(0)
  end

  it["can parse complex structures"] = function()
    local data = wax.json.parse('{"num":123,"str":"hi","bool":true,"invalid":false,"array":["a",1,false],"nested":{"key":"val"}}')

    expect(data.num).should_be(123)
    expect(data.str).should_be('hi')
    expect(data.bool).should_be(true)
    expect(data.invalid).should_be(false)
    expect(data.nested.key).should_be('val')

    expect(#data.array).should_be(3)

    expect(data.array[1]).should_be('a')
    expect(data.array[2]).should_be(1)
    expect(data.array[3]).should_be(false)
  end
end

describe["JSON generation"] = function()
  it["can generate nulls"] = function()
    expect(wax.json.generate(nil)).should_be('null')
  end

  it["can generate numbers"] = function()
    expect(wax.json.generate(123)).should_be('123')
  end

  it["can generate floats"] = function()
    expect(wax.json.generate(12.34)).should_be('12.34')
  end

  it["can generate booleans"] = function()
    expect(wax.json.generate(false)).should_be('false')
    expect(wax.json.generate(true)).should_be('true')
  end

  it["can generate empty hashes"] = function()
    expect(wax.json.generate({})).should_be("{}")
  end

  it["can generate arrays"] = function()
    expect(wax.json.generate({'a',2,false})).should_be('["a",2,false]')
  end

  it["can generate hashes"] = function()
    local json = wax.json.generate({a=1,b=2.3,c=4})
    expect(json:find('"a":1')).should_not_be(nil)
    expect(json:find('"b":2.3')).should_not_be(nil)
    expect(json:find('"c":4')).should_not_be(nil)
  end

  it["can generate complex objects"] = function()
    local json = wax.json.generate({bool=false,valid=true,array={1,2,3,'4'},tbl={k='v',f=1.2}})
    expect(json:find('"bool":false')).should_not_be(nil)
    expect(json:find('"valid":true')).should_not_be(nil)
    expect(json:find('"tbl":{"k":"v","f":1.2}')).should_not_be(nil)
    expect(json:find('"array":%[1,2,3,"4"%]')).should_not_be(nil)
  end

  it["generates nulls for functions"] = function()
    expect(wax.json.generate(function()end)).should_be('null')
  end

  it["generates hashes for mixed tables"] = function()
    local json = wax.json.generate({1,2,c=3})
    expect(json:find('"1":1')).should_not_be(nil)
    expect(json:find('"2":2')).should_not_be(nil)
    expect(json:find('"c":3')).should_not_be(nil)
  end

  it["generates deeply nested hashes"] = function()
    local json = wax.json.generate({a={b={c={d={e=1}}}}})
    expect(json).should_be('{"a":{"b":{"c":{"d":{"e":1}}}}}')
  end

  it["generates deeply nested arrays"] = function()
    local json = wax.json.generate({1,{2,{3,{4,{5,6}}}}})
    expect(json).should_be('[1,[2,[3,[4,[5,6]]]]]')
  end
end
