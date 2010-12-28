

waxClass{"StatesTable", UITableViewController, protocols = {"UITableViewDataSource", "UITableViewDelegate"}}

function init(self)
  self.super:init()

  -- Loads plist from bundle
  self.states = NSArray:arrayWithContentsOfFile("states.plist")

  self:setTitle("States")
  return self
end

function viewDidLoad(self)
  self:tableView():setDataSource(self)
  self:tableView():setDelegate(self)
end

-- DataSource
-------------
function numberOfSectionsInTableView(self, tableView)
  return 1
end

function tableView_numberOfRowsInSection(self, tableView, section)
  return #self.states
end

function tableView_cellForRowAtIndexPath(self, tableView, indexPath)  
  local identifier = "StateCell"
  local cell = tableView:dequeueReusableCellWithIdentifier(identifier) or
               UITableViewCell:initWithStyle_reuseIdentifier(UITableViewCellStyleDefault, identifier)  

  local state = self.states[indexPath:row() + 1]
  cell:textLabel():setText(state["name"]) -- Must +1 because lua arrays are 1 based
  cell:setAccessoryType(UITableViewCellAccessoryDisclosureIndicator)

  return cell
end

-- Delegate
-----------
function tableView_didSelectRowAtIndexPath(self, tableView, indexPath)
  self:tableView():deselectRowAtIndexPath_animated(indexPath, true)
  local state = self.states[indexPath:row() + 1]
  
  local viewController = CapitalsTable:init(state)
  self:navigationController():pushViewController_animated(viewController, true)
end
