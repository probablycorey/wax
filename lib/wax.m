//
//  ObjLua.m
//  Lua
//
//  Created by ProbablyInteractive on 5/27/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "wax.h"
#import "wax_class.h"
#import "wax_instance.h"
#import "wax_struct.h"
#import "wax_helpers.h"
#import "wax_GarbageCollection.h"

#import "lauxlib.h"
#import "lobject.h"
#import "lualib.h"

static void addGlobals(lua_State *L);
static int tolua(lua_State *L);
static int toobjc(lua_State *L);
static int exitApp(lua_State *L);
static int objcDebug(lua_State *L);

lua_State *wax_currentLuaState() {
    static lua_State *L;    
    if (!L) L = lua_open();
    
    return L;
}

void uncaughtExceptionHandler(NSException *e) {
    printf("ERROR: Uncaught exception %s\n", [[e description] UTF8String]);
}

void wax_startWithExtensions(lua_CFunction func, ...) {  
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler); 
     
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager changeCurrentDirectoryPath:[[NSBundle mainBundle] bundlePath]];
    
    lua_State *L = wax_currentLuaState();
    
    luaL_openlibs(L); 
    luaopen_wax(L);
    
    if (func) { // Load extentions
        func(L);

        va_list ap;
        va_start(ap, func);
        while((func = va_arg(ap, lua_CFunction))) func(L);
            
        va_end(ap);
    }

    addGlobals(L);
    
    [wax_GarbageCollection start];

    // Load all the wax lua scripts
    if (luaL_dofile(L, WAX_DATA_DIR "scripts/wax/init.lua") != 0) {
        fprintf(stderr,"Fatal error opening wax scripts: %s\n", lua_tostring(L,-1));
    }
    
    // Start the user's init script!
    if (luaL_dofile(L, WAX_DATA_DIR "scripts/AppDelegate.lua") != 0) {
        fprintf(stderr,"Fatal error: %s\n", lua_tostring(L,-1));
    }
	
    NSDictionary *env = [[NSProcessInfo processInfo] environment];
    if ([[env objectForKey:@"WAX_TEST"] isEqual:@"YES"]) { // Should we run the tests?
        if (luaL_dofile(L, WAX_DATA_DIR "scripts/tests/init.lua") != 0) {
            fprintf(stderr,"Fatal error running tests: %s\n", lua_tostring(L,-1));
        }
        exit(1);
    }
	else if ([[env objectForKey:@"WAX_REPL"] isEqual:@"YES"]) { // Should we run the repl?
		if (luaL_dofile(L, WAX_DATA_DIR "scripts/wax/repl.lua") != 0) {
			fprintf(stderr,"Fatal error running tests: %s\n", lua_tostring(L,-1));
		}
		exit(1);
	}
}


void wax_start() {
    wax_startWithExtensions(nil);
}

void wax_end() {
    lua_close(wax_currentLuaState());
}

void luaopen_wax(lua_State *L) {
    luaopen_wax_class(L);
    luaopen_wax_instance(L);
    luaopen_wax_struct(L);
}

static void addGlobals(lua_State *L) {
    lua_getglobal(L, "wax");
    if (lua_isnil(L, -1)) {
        lua_pop(L, 1); // Get rid of the nil
        lua_newtable(L);
        lua_pushvalue(L, -1);
        lua_setglobal(L, "wax");
    }
    
    lua_pushnumber(L, WAX_VERSION);
    lua_setfield(L, -2, "version");
    
    lua_pushstring(L, WAX_DATA_DIR);
    lua_setfield(L, -2, "root");
        
    lua_pop(L, 1); // pop the wax global off
    
    // Functions
    lua_pushcfunction(L, tolua);
    lua_setglobal(L, "tolua");
    
    lua_pushcfunction(L, toobjc);
    lua_setglobal(L, "toobjc");
    
    lua_pushcfunction(L, exitApp);
    lua_setglobal(L, "exitApp");

    lua_pushcfunction(L, objcDebug);
    lua_setglobal(L, "debugger");
    
    lua_pushstring(L, [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] UTF8String]);
    lua_setglobal(L, "NSDocumentDirectory");
    
    lua_pushstring(L, [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] UTF8String]);
    lua_setglobal(L, "NSLibraryDirectory");
    
    lua_pushstring(L, [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] UTF8String]);
    lua_setglobal(L, "NSCacheDirectory");

}

static int tolua(lua_State *L) {
    if (lua_isuserdata(L, 1)) { // If it's not userdata... it's already lua!
        wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 1, WAX_INSTANCE_METATABLE_NAME);
        wax_fromInstance(L, instanceUserdata->instance);
    }
    
    return 1;
}

static int toobjc(lua_State *L) {
    id *instancePointer = wax_copyToObjc(L, "@", 1, nil);
    id instance = *(id *)instancePointer;
    
    wax_instance_create(L, instance, NO);
    
    if (instancePointer) free(instancePointer);
    
    return 1;
}

static int exitApp(lua_State *L) {
    exit(0);
    return 0;
}

static int objcDebug(lua_State *L) {
    NSLog(@"DEBUGGEG!");
    return 0;
}