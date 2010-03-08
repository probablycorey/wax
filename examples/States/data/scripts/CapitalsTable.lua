waxClass{"CapitalsTable", UITableViewController, protocols = {"UITableViewDataSource"}}

function init(self, state)
  self.super:initWithStyle(UITableViewStyleGrouped)
  self.state = state
  self:setTitle(state.name)
  return self
end


function viewDidLoad(self)
  self:tableView():setDataSource(self)
end

-- DataSource
-------------
function numberOfSectionsInTableView(self, tableView)
  return 1
end

function tableView_numberOfRowsInSection(self, tableView, section)
  return #table.keys(self.state)
end

function tableView_cellForRowAtIndexPath(self, tableView, indexPath)  
  local identifier = "CapitalsTableCell"
  local cell = tableView:dequeueReusableCellWithIdentifier(identifier) or
               UITableViewCell:initWithStyle_reuseIdentifier(UITableViewCellStyleValue1, identifier)  

  local key = table.keys(self.state)[indexPath:row() + 1]
  cell:detailTextLabel():setText(tostring(self.state[key]))
  cell:textLabel():setText(key)
  cell:setSelectionStyle(UITableViewCellSelectionStyleNone)

  return cell
end
