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

#import "lauxlib.h"
#import "lobject.h"
#import "lualib.h"

#import "luasocket.h"
#import "unix.h"
#import "mime.h"

lua_State *current_lua_state() {
    static lua_State *L;    
    if (!L) L = lua_open();    
    
    return L;
}

void objlua_start() {
    char *mainFile = "Data/Scripts/init.lua";
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager changeCurrentDirectoryPath:[[NSBundle mainBundle] bundlePath]];
    lua_State *L = current_lua_state();
    
    luaL_openlibs(L); 
    luaopen_socket_core(L);
    luaopen_mime_core(L);
    luaopen_objlua(L);
        
    
    if (luaL_dofile(L, mainFile) != 0) fprintf(stderr,"%s\n",lua_tostring(L,-1));
}

void objlua_end() {
    lua_close(current_lua_state());
}

void luaopen_objlua(lua_State *L) {
    luaopen_objlua_class(L);
    luaopen_objlua_instance(L);
}