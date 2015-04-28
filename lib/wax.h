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


// run lua string
int wax_runLuaString(const char *script);

//run lua byte code
int wax_runLuaByteCode(NSData *data, NSString *name);


typedef  void (*WaxLuaRuntimeErrorHandler)(NSString *reason, BOOL willExit);

//lua runtime error callback
void wax_setLuaRuntimeErrorHandler(WaxLuaRuntimeErrorHandler handler);

WaxLuaRuntimeErrorHandler wax_getLuaRuntimeErrorHandler();