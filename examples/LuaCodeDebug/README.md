wax Lua debug
---------
you can use Lua debugger tool to debug your lua code

Use steps
--------
* import wax and mobedebug, like podfile

```
	pod 'wax', :path=>'../../'
	pod 'mobdebug', :path=>'../../tools/mobdebug'
```
* download [ZeroBraneStudio](https://github.com/pkulchenko/ZeroBraneStudio)
* run ZeroBraneStudio: double click `zbstudio/ZeroBraneStudio` or `sh zbstudio.sh`
* import lua code: click the 6th button![Smaller icon](https://github.com/pkulchenko/ZeroBraneStudio/blob/master/zbstudio/res/24/DIR-SETUP.png?raw=true), choose your lua code's root directory
* start debug server: click Project->Start Debugger Server.
* run this code before you enter debug

```
    wax_start(nil, nil);//must start before debug
    extern void luaopen_mobdebug_scripts(void* L);
    luaopen_mobdebug_scripts(wax_currentLuaState());
```
* add```require('mobdebug').start('YOUR_MAC_IP_ADDRESS')```to your lua code. if you use simulator `'YOUR_MAC_IP_ADDRESS'` can be empty
* launch your app，when `require('mobdebug').start()` is invoked, ZeroBraneStudio's dock will become active, then you should add breakpoint.

debug functions
--------
step into:![Smaller icon](https://github.com/pkulchenko/ZeroBraneStudio/blob/master/zbstudio/res/24/DEBUG-STEP-INTO.png?raw=true)  
step over:![Smaller icon](https://github.com/pkulchenko/ZeroBraneStudio/blob/master/zbstudio/res/24/DEBUG-STEP-OVER.png?raw=true)  
step out:![Smaller icon](https://github.com/pkulchenko/ZeroBraneStudio/blob/master/zbstudio/res/24/DEBUG-STEP-OUT.png?raw=true)  
run to cursor:![Smaller icon](https://github.com/pkulchenko/ZeroBraneStudio/blob/master/zbstudio/res/24/DEBUG-RUN-TO.png?raw=true)   
continue:![Smaller icon](https://github.com/pkulchenko/ZeroBraneStudio/blob/master/zbstudio/res/24/DEBUG-START.png?raw=true)
kill app:![Smaller icon](https://github.com/pkulchenko/ZeroBraneStudio/blob/master/zbstudio/res/24/DEBUG-STOP.png?raw=true)  

remote console:print variable, or call function  
watch：watch some variable   
stack：show the lua stack  


demo overview
--------
![overview](https://raw.githubusercontent.com/alibaba/wax/master/examples/LuaCodeDebug/readMeRes/debug_overview.png)
