require "SimpleMapController"

waxClass{"AppDelegate", protocols = {"UIApplicationDelegate"}}

function applicationDidFinishLaunching(self, application)
  local frame = UIScreen:mainScreen():bounds()
  self.window = UIWindow:initWithFrame(frame)
  self.window:setBackgroundColor(UIColor:whiteColor())
  
  self.controller = SimpleMapController:init()
  self.window:setRootViewController(self.controller)
  
  self.window:makeKeyAndVisible()
end
