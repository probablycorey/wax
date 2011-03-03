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

function removeDeclaration(t, options)
  return string.match(wax.xml.generate(t, options or {}), "^<?[^>]+>%s*(.*)%s+")
end

describe["XML generating"] = function()

  it["generates empty tag"] = function()
    local result = removeDeclaration({name = {}})
    
    expect(type(result)).should_be("string")
    expect(result).should_be("<name/>")
  end
  
  it["generates tag with content"] = function()
    local result = removeDeclaration({name = "content"})
  
    expect(result).should_be("<name>content</name>")
  end
  
  it["generates tag with attributes"] = function()
    local result = removeDeclaration(
      {name = {
        text = "content",
        attrs = {cool = "yes"}}})
        
    expect(result).should_be("<name cool=\"yes\">content</name>")
  end
  
  it["generates tag with namespace"] = function()
    local result = removeDeclaration(
      {["my:name"] = {
        text = "content",
        attrs = {["xmlns:my"] = "http://wtf.org"}}})
      
    expect(result).should_be("<my:name xmlns:my=\"http://wtf.org\">content</my:name>")
  end
  
  
  it["generates attribute with namespace"] = function()
    local result = removeDeclaration(
      {name = {
        text = "content",
        attrs = {["xmlns:my"] = "http://wtf.org", ["my:cool"] = "yes"}}})
    
    expect(result:find("xmlns:my=\"http://wtf.org\"")).should_not_be(nil)
    expect(result:find("my:cool=\"yes\"")).should_not_be(nil)
  end

  it["generates multiple elements from an array"] = function()
    local result = removeDeclaration(
      {names = 
        {name = {
          { text = "corey" },
          { text = "bob" },
          { text = "phill" }
          }}})
    expect(result:find("<name>corey</name>")).should_not_be(nil)
    expect(result:find("<name>bob</name>")).should_not_be(nil)
    expect(result:find("<name>phill</name>")).should_not_be(nil)
    expect(result:find("<names><name>")).should_not_be(nil)
    expect(result:find("</name></names>")).should_not_be(nil)
  end
  
  it["generates elements named text (with optional names specified)"] = function()
    local result = removeDeclaration(
      {word = {
        text = {
          moo = "inside"
        }}}, {text = "moo"})
    
    expect(result).should_be("<word><text>inside</text></word>")
  end
  
  it["generates elements named attrs (with optional names specified)"] = function()
    local result = removeDeclaration(
      {word = {
        cow = {name = "works"},
        attrs = "inside"
        }}, {attrs = "cow"})
  
    expect(result).should_be("<word name=\"works\"><attrs>inside</attrs></word>")
  end
end
