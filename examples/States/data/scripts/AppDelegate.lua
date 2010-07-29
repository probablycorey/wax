require "StatesTable"
require "CapitalsTable"

waxClass{"AppDelegate", protocols = {"UIApplicationDelegate"}}

function applicationDidFinishLaunching(self, application)
  local frame = UIScreen:mainScreen():bounds()
  self.window = UIWindow:initWithFrame(frame)
  self.window:setBackgroundColor(UIColor:orangeColor())  
  self.window:makeKeyAndVisible()
  
  local statesTable = StatesTable:init()
  self.navigationController = UINavigationController:initWithRootViewController(statesTable)

  self.window:addSubview(self.navigationController:view())
end

