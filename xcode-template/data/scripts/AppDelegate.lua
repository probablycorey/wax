waxClass{"AppDelegate", protocols = {"UIApplicationDelegate"}}

-- Well done! You are almost ready to run a lua app on your iPhone!
--
-- Just run the app (⌘↵) in the simulator or on a device! 
-- You should see a dull, bland "hello world" app popup!
--
-- If your prefer using TextMate to edit the Lua code just type 
-- 'rake tm' from the command line to setup a wax TextMate project.
--
-- What's next?
-- 1. Check out some of the example apps to learn how to do
--    more complicated apps.
-- 2. Then you start writing your app!
-- 3. Let us know if you need any help at http://groups.google.com/group/iphonewax

function applicationDidFinishLaunching(self, application)
  local frame = UIScreen:mainScreen():bounds()
  self.window = UIWindow:initWithFrame(frame)
  self.window:setBackgroundColor(UIColor:orangeColor())


  local label = UILabel:initWithFrame(CGRect(0, 100, 320, 40))
  label:setFont(UIFont:boldSystemFontOfSize(30))
  label:setColor(UIColor:orangeColor())
  label:setText("Hello Lua!")
  label:setTextAlignment(UITextAlignmentCenter)    
  self.window:addSubview(label)
  
  self.window:makeKeyAndVisible()
end