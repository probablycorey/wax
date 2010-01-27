-- Wax Initial Setup
--------------------
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
-- 1. Open up the AppDelegate.m file and add some extensions (like the HTTPotluck for networking)
-- 2. ???

local window = UI.Application:sharedApplication():keyWindow()
window:setBackgroundColor(UI.Color:orangeColor())

label = UI.Label:initWithFrame(CGRect(0, 100, 320, 40))
label:setFont(UI.Font:boldSystemFontOfSize(30))
label:setColor(UI.Color:orangeColor())
label:setText("Hello Lua!")
label:setTextAlignment(UITextAlignmentCenter)

window:addSubview(label)
