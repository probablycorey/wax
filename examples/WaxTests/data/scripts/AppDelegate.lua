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
  local window = UI.Window:initWithFrame(frame)
  window:setBackgroundColor(UI.Color:orangeColor())
  
  
  local label = UI.Label:initWithFrame(CGRect(0, 100, 320, 40))
  label:setFont(UI.Font:boldSystemFontOfSize(30))
  label:setColor(UI.Color:orangeColor())
  label:setText("OMG! TESTING!")
  label:setTextAlignment(UITextAlignmentCenter)    
  window:addSubview(label)
  
  window:makeKeyAndVisible()
end