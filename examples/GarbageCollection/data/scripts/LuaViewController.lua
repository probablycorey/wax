oinkClass("LuaViewController", UI.ViewController)

function init(self)
  self.super:init()
  self.label = UI.Label:initWithFrame(CGRect(0, 100, 320, 100))
  self.string = toobjc("Just for memory testing")
  return self
end

function loadView(self)
  self:setView(UI.View:init())

  self.label:setFont(UI.Font:boldSystemFontOfSize(30))
  self.label:setColor(UI.Color:orangeColor())
  self.label:setText("Random Number: " .. tostring(math.random(1, 100)))
  self.label:setTextAlignment(UITextAlignmentCenter)
  
  self:view():addSubview(self.label)
end