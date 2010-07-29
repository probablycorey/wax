require "BlueController"
require "OrangeController"

-- these are global just to make the code smaller... IT'S GENERALLY A BAD IDEA
blueController = BlueController:init()
orangeController = OrangeController:init()

waxClass{"AppDelegate", protocols = {"UIApplicationDelegate"}}

function applicationDidFinishLaunching(self, application)
  local frame = UIScreen:mainScreen():bounds()
  self.window = UIWindow:initWithFrame(frame)

  
  self.window:addSubview(blueController:view())
  
  self.window:makeKeyAndVisible()
end
