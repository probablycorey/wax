waxClass{"AppDelegate", protocols = {"UIApplicationDelegate"}}

function applicationDidFinishLaunching(self, application)
  -- local frame = UIScreen:mainScreen():bounds()
  -- self.window = UIWindow:initWithFrame(frame)
  -- self.window:setBackgroundColor(UIColor:orangeColor())
  -- 
  -- local view = UIView:init()
  -- 
  -- local button = UIButton:buttonWithType(UIButtonTypeRoundedRect)
  -- button:setTitle_forState("Test GC", UIControlStateNormal)
  -- button:setFrame(CGRect(100, 100, 120, 100))
  -- button:addTarget_action_forControlEvents(self, "gcTouched:", UIControlEventTouchUpInside)
  -- self.window:addSubview(button)
  
  -- self.window:makeKeyAndVisible()
end

-- function gcTouched(self, sender)
--   puts("boom")
--   collectgarbage("collect")
-- end