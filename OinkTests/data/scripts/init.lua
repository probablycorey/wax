require "oink"

window = UI.Application:sharedApplication():keyWindow()
window:setBackgroundColor(UI.Color:orangeColor())
label = UI.Label:initWithFrame(CGRect(0, 100, 320, 40))
label:setFont(UI.Font:boldSystemFontOfSize(30))
label:setColor(UI.Color:orangeColor())
label:setText("LOOK! IT WORKED!")
label:setTextAlignment(UITextAlignmentCenter)
window:addSubview(label)

-- start coding your stuff!
