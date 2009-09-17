Setup
-----

I'm assuming you've got wax... if not, grab it at http://github.com/probablycorey/wax

• Create a new "Window-based Application" iPhone project in xcode

• Drag the wax folder into the your <PROJECT ROOT> folder (the actual folder via Finder/Terminal not into xCode). Then drag the <PROJECT ROOT>/wax/src folder into the xcode "Groups & Files" pane. You want to make sure "Copy items into destination group's folder" is NOT checked and "Recursively create groups for any added folders" is selected. 

• In your UIApplication delegate file add...
    #import "wax.h"

• In your UIApplication delegate's "applicationDidFinishLaunching:" method (after the call to [window makeKeyAndVisible]) add...
  wax_start();
  // OR if you want to add extensions
  // wax_startWithExtensions(luaopen_libXfunction, luaopen_libYfunction, nil);
    
• Add a run script build phase (This will copy all your lua scripts into the app bundle every time you build the project.)
1.) In the xcode Groups & Files pane right click "Targets"
2.) Click Add > New Build Phase > New Run Script Build Phase
3.) A weird little editor window should pop up. In the Script text area write 
  wax/copy_scripts.sh
  
• Now build your app! It should compile and you should have a new folder named "data" in <PROJECT ROOT> (If you want to see the data folder in xcode you have to add the xcode project, this is optional though.)

• When you run the app, it will run the lua script located at /data/scripts/init.lua Put your magic in there

Examples
--------

• Simple UITableViewController Example

waxClass("BasicTableViewController", UI.TableViewController, {protocols = {"UITableViewDelegate", "UITableViewDataSource"}})

function init(self)
  self.super:init()
  self.states = {"Michigan", "California", "New York", "Illinois", "Minnesota", "Florida"}
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
  local identifier = "BasicableViewCell"
  local cell = tableView:dequeueReusableCellWithIdentifier(identifier)
  cell = cell or UI.TableViewCell:initWithStyle_reuseIdentifier(UITableViewCellStyleDefault, identifier)  

  cell:setText(self.stats[indexPath:row() + 1]) -- Must +1 because lua arrays are 1 based
    
  return cell
end

-- Delegate
-----------
function tableView_didSelectRowAtIndexPath(self, tableView, indexPath)
  tableView:deselectRowAtIndexPath_animated(indexPath, true)
  -- Do something cool here!
end

Trouble shooting
----------------
* bad argument #1 to '???' (wax.instance expected, got ???)
Usually means you called a function with a '.' instead of a ':'

* Error invoking method 'addSubview:' on 'UIWindow' because *** -[??? superview]: unrecognized selector sent to instance
If you are trying to add a UIViewController, make sure you are adding the view, not the viewController.


Known issues
------------
Don't override dealloc in lua... this will break.