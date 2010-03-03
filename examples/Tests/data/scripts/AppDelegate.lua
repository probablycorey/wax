waxClass{"AppDelegate", protocols = {"UIApplicationDelegate"}}

-- Well done! You are almost ready to run a lua app on your iPhone!
--
-- Just run the app (⌘↵) in the simulator or on a device! 
-- You should see a dull, bland "hello world" app popup!
--
-- I prefer using TextMate to edit the Lua code. If that is your editor of
-- choice just type 'rake tm' from the command line to setup a wax
-- TextMate project.
--
-- What's next?
-- 1. Check out some of the example apps to learn how to do
--    more complicated apps.
-- 2. Then you start writing your app!
-- 3. Let us know if you need any help at http://groups.google.com/group/iphonewax

function applicationDidFinishLaunching(self, application)
  local frame = UI.Screen:mainScreen():bounds()
  self.window = UI.Window:initWithFrame(frame)
  self.window:setBackgroundColor(UI.Color:orangeColor())

  local view = UI.View:init()
  
  local button = UI.Button:buttonWithType(UIButtonTypeRoundedRect)
  button:setTitle_forState("Test GC", UIControlStateNormal)
  button:setFrame(CGRect(100, 100, 120, 100))
  button:addTarget_action_forControlEvents(self, "gcTouched:", UIControlEventTouchUpInside)
  self.window:addSubview(button)
  
  self.window:makeKeyAndVisible()
end

function gcTouched(self, sender)
  puts("boom")
  collectgarbage("collect")
end