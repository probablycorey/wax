If you don't want to include the wax source, you can just use Wax.Framework

How
---

1. Open your project in xcode and drag Wax.framework into the frameworks folder
2. In the Groups & Files Pane, expand the "Targets" section
3. Right click on your project and select Add > New Build Phase > New Run Script Build Phase
4. A weird little window will open up that lets you input a script, add this line...

    `"$PROJECT_DIR/wax.framework/Resources/copy-scripts.sh"`
    
    
All done, build your app and you will see Lua printed out some code, it will tell you where to keep your scripts
