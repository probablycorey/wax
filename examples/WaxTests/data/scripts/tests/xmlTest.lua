describe["XML parsing"] = function()
  it["parses empty tag"] = function()
    local result = wax.xml.parse("<name></name>")
    expect(type(result)).should_be("table")
    expect(type(result.name)).should_be("table")
    
    expect(result.text).should_be(nil)
  end
  
  it["parses tag with content"] = function()
    local result = wax.xml.parse("<name>content</name>")    
    expect(result.name.text).should_be("content")
  end
  
  it["parses tag with attributes"] = function()
    local result = wax.xml.parse("<name cool='yes'>content</name>")    
    expect(result.name.attrs.cool).should_be("yes")
  end
  
  it["parses tag with namespace"] = function()
    local result = wax.xml.parse("<my:name xmlns:my='http://wtf.org'>content</my:name>")    
    expect(result['my:name'].text).should_be("content")
  end
  
  
  it["parses attribute with namespace"] = function()
    local result = wax.xml.parse("<name xmlns:my='http://wtf.org' my:cool='yes'>content</name>")    
    expect(result.name.attrs["my:cool"]).should_be("yes")
  end
  
  it["parses nested elements with the same name as an array"] = function()
    local result = wax.xml.parse("<names><name>corey</name><name>bob</name><name>phill</name></names>")    
    expect(type(result.names.name)).should_be("table")
    expect(#result.names.name).should_be(3)
    expect(result.names.name[1].text).should_be("corey")
    expect(result.names.name[2].text).should_be("bob")
    expect(result.names.name[3].text).should_be("phill")
  end
  
  it["parses elements named text (with optional names specified)"] = function()
    local result = wax.xml.parse("<word><text>inside</text></word>", {text = "_text"})
    expect(type(result.word.text)).should_be("table")
    expect(result.word.text._text).should_be("inside")
  end
  
  it["parses elements named attrs (with optional names specified)"] = function()
    local result = wax.xml.parse("<word name='works'><attrs>inside</attrs></word>", {attrs = "_attrs"})
    expect(type(result.word.attrs)).should_be("table")
    expect(result.word._attrs.name).should_be("works")
  end
  
end

