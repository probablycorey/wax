//
//  ObjLua.m
//  Lua
//
//  Created by ProbablyInteractive on 5/27/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "ObjLua.h"
#import "ObjLua_Class.h"
#import "ObjLua_Instance.h"
#import "ObjLua_Struct.h"
#import "ObjLua_Helpers.h"

#import "lauxlib.h"
#import "lobject.h"
#import "lualib.h"

lua_State *current_lua_state() {
    static lua_State *L;    
    if (!L) L = lua_open();    
    
    return L;
}

void uncaughtExceptionHandler() {
    // TODO: Make this error a little more helpful...
    NSLog(@"LOOK! THERE WAS AN EXCEPTION!");
}

void objlua_startWithExtensions(lua_CFunction func, ...) {
    char *mainFile = "Data/Scripts/init.lua";
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager changeCurrentDirectoryPath:[[NSBundle mainBundle] bundlePath]];
    lua_State *L = current_lua_state();
    
    luaL_openlibs(L); 
    luaopen_objlua(L);
    
    if (func) { // Load extentions
        func(L);

        va_list ap;
        va_start(ap, func);
        while(func = va_arg(ap, lua_CFunction)) func(L);
            
        va_end(ap);
    }
    
    NSSetUncaughtExceptionHandler(uncaughtExceptionHandler);
    
    addGlobals(L);
        
    if (luaL_dofile(L, mainFile) != 0) fprintf(stderr,"Fatal Error: %s\n",lua_tostring(L,-1));    
}

void objlua_start() {
    objlua_startWithExtensions(nil);
}

void objlua_end() {
    lua_close(current_lua_state());
}

void luaopen_objlua(lua_State *L) {
    luaopen_objlua_class(L);
    luaopen_objlua_instance(L);
    luaopen_objlua_struct(L);
}

static void addGlobals(lua_State *L) {
    lua_pushcfunction(L, tolua);
    lua_setglobal(L, "tolua");
    
    lua_pushcfunction(L, exitApp);
    lua_setglobal(L, "exitApp");
    
    lua_pushcclosure(L, objcDebug, 0);
    lua_setglobal(L, "objcDebug");

}

static int tolua(lua_State *L) {
    if (lua_isuserdata(L, 1)) { // If it's not userdata... it's already lua!
        ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);
        objlua_from_objc_instance(L, objLuaInstance->objcInstance);
    }
    
    return 1;
}

static int exitApp(lua_State *L) {
    exit(0);
    return 0;
}

static int objcDebug(lua_State *L) {
    //Debugger();
    NSLog(@"I don't know how this will work yet. For now just set a breakpoint in the method.");
    return 0;
}