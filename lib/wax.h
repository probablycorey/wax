//  Created by ProbablyInteractive.
//  Copyright 2009 Probably Interactive. All rights reserved.

#import <Foundation/Foundation.h>
#import "lua.h"

#define WAX_VERSION 0.93

void wax_setup();
void wax_start(char *initScript, lua_CFunction extensionFunctions, ...);
void wax_startWithServer();
void wax_end();

lua_State *wax_currentLuaState();

void luaopen_wax(lua_State *L);

#pragma mark add by junzhan


//you should call wax_start before these function.
// run lua string.
int wax_runLuaString(const char *script);

//run lua byte code
int wax_runLuaByteCode(NSData *data, NSString *name);

//run lua file
int wax_runLuaFile(const char *filePath);




//lua runtime error callback
typedef  void (*WaxLuaRuntimeErrorHandler)(NSString *reason, BOOL willExit);

void wax_setLuaRuntimeErrorHandler(WaxLuaRuntimeErrorHandler handler);

WaxLuaRuntimeErrorHandler wax_getLuaRuntimeErrorHandler();