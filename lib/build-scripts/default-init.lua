-- Wax Initial Setup
--------------------
-- Well done! You are pretty much finished with the setup!
--
-- Just run the app (⌘↵) in the simulator or on a device! 
-- You should see a dull, bland "hello world" app popup!
--
-- What's next?
-- 1. I don't know, I need to figure out how to ease people
--    into this framework.
-- 2. Awesomeness

require "wax"

window = UI.Application:sharedApplication():keyWindow()
window:setBackgroundColor(UI.Color:orangeColor())

label = UI.Label:initWithFrame(CGRect(0, 100, 320, 40))
label:setFont(UI.Font:boldSystemFontOfSize(30))
label:setColor(UI.Color:orangeColor())
label:setText("Hello Lua!")
label:setTextAlignment(UITextAlignmentCenter)

window:addSubview(label)
