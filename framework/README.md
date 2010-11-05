If you don't want to include the wax source, you can just use Wax.Framework

How to add Wax to an exisitng project
---

1. Open your project in xcode and drag Wax.framework into the frameworks folder. Make sure you click the "Copy items into destination group's folder" box.
2. In the Groups & Files Pane, expand the "Targets" section
3. Right click on your project and select Add > New Build Phase > New Run Script Build Phase
4. A weird little window will open up that lets you input a script, add this line...

    `"$PROJECT_DIR/wax.framework/Resources/copy-scripts.sh"`

5. Open up your AppDelegate file and import the wax header file by
   adding this line...

    `#import "wax/wax.h"

6. In your AppDelegate's *application:didFinishLaunchingWithOptions:*
   method, add this line.

   `wax_start()`
   `// To add wax with extensions, use this line instead`
   `// wax_startWithExtensions(luaopen_wax_http, luaopen_wax_json, luaopen_wax_xml, luaopen_wax_filesystem, nil);`


All done, build your app and you will see Lua printed out some code, it will tell you where to keep your scripts
