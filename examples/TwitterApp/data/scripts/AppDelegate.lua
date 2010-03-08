require "TwitterTableViewController"

waxClass{"AppDelegate", protocols = {"UIApplicationDelegate"}}

function applicationDidFinishLaunching(self, application)
  local frame = UIScreen:mainScreen():bounds()
  self.window = UIWindow:initWithFrame(frame)
  self.window:setBackgroundColor(UIColor:orangeColor())

  self.viewController = TwitterTableViewController:init()
  self.window:addSubview(self.viewController:view())

  self.window:makeKeyAndVisible()
end