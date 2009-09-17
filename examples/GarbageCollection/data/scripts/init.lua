require "wax"
require "MainViewController"

window = UI.Application:sharedApplication():keyWindow()
window:setBackgroundColor(UI.Color:orangeColor())

viewController = MainViewController:init()
navViewController = UI.NavigationController:initWithRootViewController(viewController)
window:addSubview(navViewController:view())