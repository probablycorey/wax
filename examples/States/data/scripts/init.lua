require "wax"
require "StatesTable"

window = UI.Application:sharedApplication():keyWindow()

statesTable = StatesTable:init()
navigationController = UI.NavigationController:initWithRootViewController(statesTable)

window:addSubview(navigationController:view())

