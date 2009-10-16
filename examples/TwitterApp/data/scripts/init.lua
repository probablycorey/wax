require "wax"
require "TwitterTableViewController"

window = UI.Application:sharedApplication():keyWindow()

viewController = TwitterTableViewController:init()
window:addSubview(viewController:view())