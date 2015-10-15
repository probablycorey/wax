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
* import lua code: click the 6th button[Smaller icon](https://github.com/pkulchenko/ZeroBraneStudio/blob/master/zbstudio/res/24/DIR-SETUP.png?raw=true), choose your lua code directory
* start debug server: click Project->Start Debugger Server.
* run this code before you enter debug

```
    wax_start(nil, nil);//must start before debug
    extern void luaopen_mobdebug_scripts(void* L);
    luaopen_mobdebug_scripts(wax_currentLuaState());
```
* add```require('mobdebug').start('YOUR_MAC_IP_ADDRESS')```to your lua code. if you use simulator `'YOUR_MAC_IP_ADDRESS'` can be empty

