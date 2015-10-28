require "TwitterTableViewController"

waxClass{"AppDelegate", protocols = {"UIApplicationDelegate"}}

function applicationDidFinishLaunching(self, application)
  local frame = UIScreen:mainScreen():bounds()
  self.window = UIWindow:initWithFrame(frame)
  self.window:setBackgroundColor(UIColor:orangeColor())

  self.viewController = TwitterTableViewController:init()
  self.window:setRootViewController(self.viewController)

  self.window:makeKeyAndVisible()
end