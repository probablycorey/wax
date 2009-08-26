require "LuaViewController"

oinkClass("MainViewController", UI.ViewController)

function init(self)
  self.super:init()
  self.objcButton = UI.Button:buttonWithType(UIButtonTypeRoundedRect)
  self.luaButton = UI.Button:buttonWithType(UIButtonTypeRoundedRect)  
  self.garbageButton = UI.Button:buttonWithType(UIButtonTypeRoundedRect)
  
  return self
end

function loadView(self)
  self:setView(UI.View:initWithFrame(nil))
  self:view():setBackgroundColor(UI.Color:orangeColor())
  
  self.objcButton:setTitle_forState("Push An ObjC View", UIControlStateNormal)
  self.objcButton:setFrame(CGRect(10, 100, 300, 40))
  self.objcButton:addTarget_action_forControlEvents(self, "pushViewButtonTouched:", UIControlEventTouchUpInside)
  self:view():addSubview(self.objcButton)

  self.luaButton:setTitle_forState("Push A Lua View", UIControlStateNormal)
  self.luaButton:setFrame(CGRect(10, 150, 300, 40))
  self.luaButton:addTarget_action_forControlEvents(self, "pushLuaViewButtonTouched:", UIControlEventTouchUpInside)
  self:view():addSubview(self.luaButton)
  
  self.garbageButton:setTitle_forState("Collect GARBAGE!", UIControlStateNormal)
  self.garbageButton:setFrame(CGRect(10, 200, 300, 40))
  self.garbageButton:addTarget_action_forControlEvents(self, "garbageButtonTouched:", UIControlEventTouchUpInside)
  self:view():addSubview(self.garbageButton)
end

function pushViewButtonTouched(self, button)
  local viewController = oink.class.PureViewController:init()
  self:navigationController():pushViewController_animated(viewController, true)
end

function pushLuaViewButtonTouched(self, button)
  local viewController = LuaViewController:init()
  self:navigationController():pushViewController_animated(viewController, true)
end

function garbageButtonTouched(self, button)
  collectgarbage("collect")
end