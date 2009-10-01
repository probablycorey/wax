Setup
-----

1. Download wax http://github.com/probablycorey/wax

2. From the inside the wax folder type **rake install**. This will install an xcode project template.

3. Open up xcode and create a new **Wax** project, it should be located under the **User Tempates** section. 

4. Build and Run! You've got lua running on the iPhone!


Example
-------

Simple UITableViewController Example

    waxClass{"BasicTableViewController", "UITableViewController", protocols = {"UITableViewDelegate", "UITableViewDataSource"}}

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

      cell:setText(self.states[indexPath:row() + 1]) -- Must +1 because lua arrays are 1 based

      return cell
    end

    -- Delegate
    -----------
    function tableView_didSelectRowAtIndexPath(self, tableView, indexPath)
      self:tableView():deselectRowAtIndexPath_animated(indexPath, true)
      -- Do something cool here!
    end

Created By
----------
Corey Johnson (probablycorey at gmail dot com)


More
----
* [Found Bugs?](http://github.com/probablycorey/wax/issues] - Issue tracking and release planning.
* [Mailing List][http://groups.google.com/group/iphonewax]
* [IRC: #wax](irc://chat.freenode.net/#wax) on http://freenode.net