require "SimpleMapController"

waxClass{"AppDelegate", protocols = {"UIApplicationDelegate"}}

function applicationDidFinishLaunching(self, application)
  local frame = UIScreen:mainScreen():bounds()
  self.window = UIWindow:initWithFrame(frame)
  self.window:setBackgroundColor(UIColor:whiteColor())
  
  self.controller = SimpleMapController:init()
  self.window:addSubview(self.controller:view())
  
  self.window:makeKeyAndVisible()
end
