/*
 *  ObjLua_Instance.c
 *  Lua
 *
 *  Created by ProbablyInteractive on 5/18/09.
 *  Copyright 2009 Probably Interactive. All rights reserved.
 *
 */

#import "ObjLua_Instance.h"
#import "ObjLua_Helpers.h"

#import "lauxlib.h"

static const struct luaL_Reg MetaMethods[] = {
    {"__index", __index},
    {"__newindex", __newindex},
    {"__gc", __gc},
    {"__tostring", __tostring},
    {NULL, NULL}
};

static const struct luaL_Reg Methods[] = {
    {NULL, NULL}
};

int luaopen_objlua_instance(lua_State *L) {
    luaL_newmetatable(L, OBJLUA_INSTANCE_METATABLE_NAME);
    luaL_register(L, NULL, MetaMethods);
    luaL_register(L, OBJLUA_INSTANCE_METATABLE_NAME, Methods);    
    
    return 1;
}

ObjLua_Instance *objlua_instance_create(lua_State *L, id objcInstance, BOOL isClass) {
    // Does user data already exist?
    objlua_push_userdata_for_object(L, objcInstance);
    if (lua_isnil(L, -1)) {
        lua_settop(L, -2); // pop nil stack
    }
    else {
        return lua_touserdata(L, -1);
    }
    
    size_t nbytes = sizeof(ObjLua_Instance);
    ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)lua_newuserdata(L, nbytes);
    objLuaInstance->objcInstance = objcInstance;
    objLuaInstance->isClass = isClass;
    if (!isClass) {
        [objLuaInstance->objcInstance retain];
    }
    
    // set the metatable
    luaL_getmetatable(L, OBJLUA_INSTANCE_METATABLE_NAME);
    lua_setmetatable(L, -2);

    // give it a nice clean environment
    lua_newtable(L); 
    lua_setfenv(L, -2);
    
    
    // find or create weak table
    luaL_getmetatable(L, OBJLUA_INSTANCE_METATABLE_NAME);
    lua_getfield(L, -1, "__userdata");
    
    if (lua_isnil(L, -1)) { // Create new table, add it to metatable
        lua_settop(L, -2);
        lua_newtable(L);
        lua_pushstring(L, "v");
        lua_setfield(L, -2, "__mode");
        
        
        lua_pushstring(L, "__userdata");
        lua_pushvalue(L, -2);
        lua_rawset(L, -4);        
    }

    
    // register the userdata in the weak table in the metatable (so we can access it from obj-c)
    lua_pushlightuserdata(L, objLuaInstance->objcInstance);
    lua_pushvalue(L, -4);
    lua_rawset(L, -3);
    
    lua_settop(L, -3); // Pop off table and metatable
    
    return objLuaInstance;
}

static int __index(lua_State *L) {
    lua_getfenv(L, 1);
    lua_pushvalue(L, 2);
    lua_rawget(L, 3);
    
    if (lua_isnil(L, 4)) { // Nope, couldn't find that in the userdata environment table
        lua_settop(L, 2);
        lua_pushcclosure(L, methodClosure, 2);
    }
    else {
        // Remove env table from stack
        lua_remove(L, -2);
    }
    
    return 1;
}

static int __newindex(lua_State *L) {
    // Sets new values to the userdata's environment table
    lua_getfenv(L, 1);
    lua_insert(L, 2);
    lua_rawset(L, 2);
    
    return 0;
}
    
static int __gc(lua_State *L) {
    ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);
    
    if (!objLuaInstance->isClass) {
        luaL_getmetafield(L, -1, "__userdata");
        lua_pushlightuserdata(L, objLuaInstance);
        lua_pushnil(L); // Remove this instance from the __userdata table.
        lua_rawset(L, -3);
        
        [objLuaInstance->objcInstance release];
    }
    
    return 0;
}

static int __tostring(lua_State *L) {
    ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);
    lua_pushstring(L, [[objLuaInstance->objcInstance description] UTF8String]);
    
    return 1;
}

static int methodClosure(lua_State *L) {
    // TODO this function is too complicated... Strip it down! 
    ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, lua_upvalueindex(1), OBJLUA_INSTANCE_METATABLE_NAME);
    const char *methodName = luaL_checkstring(L, lua_upvalueindex(2));    
    
    BOOL autoAlloc = NO;
    
    if (objLuaInstance->isClass && strncmp(methodName, "init", 4) == 0) {
        // If init is called on a class, allocate it.
        // This is done to get around the placeholder stuff the foundation class uses
        objLuaInstance = objlua_instance_create(L, [objLuaInstance->objcInstance alloc], NO);
        lua_replace(L, -3);
        autoAlloc = YES;
    }
    
    int luaArgumentCount = lua_gettop(L);    

    SEL selector = objlua_selector_from_method_name(methodName, luaArgumentCount);
    NSMethodSignature *signature;
    NSInvocation *invocation;

    signature = [objLuaInstance->objcInstance methodSignatureForSelector:selector];
    
    if (!signature) {
        const char *className = [NSStringFromClass([objLuaInstance->objcInstance class]) UTF8String];
        luaL_error(L, "'%s' has no method selector '%s'", className, methodName);
    }
    
    invocation = [NSInvocation invocationWithMethodSignature:signature];
        
    [invocation setTarget:objLuaInstance->objcInstance];
    [invocation setSelector:selector];
    
    int objcArgumentCount = [signature numberOfArguments] - 2; // self and _cmd are always the first two
    
    void **arguements = calloc(sizeof(void*), objcArgumentCount);
    for (int i = 0; i < luaArgumentCount; i++) {
        int arguementOffset = i + 2; // self and _cmd are always the first two
        arguements[i] = objlua_to_objc(L, [signature getArgumentTypeAtIndex:arguementOffset], i + 1);
        [invocation setArgument:arguements[i] atIndex:arguementOffset];
    }
    
    [invocation invoke];
    
    // Free the arguements
    for (int i = 0; i < objcArgumentCount; i++) {
        free(arguements[i]);
    }
    free(arguements);
    
    int methodReturnLength = [signature methodReturnLength];
    if (methodReturnLength > 0) {
        // TODO use lua buffers for strings
        void *buffer = calloc(1, methodReturnLength);
        [invocation getReturnValue:buffer];
            
        objlua_from_objc(L, [signature methodReturnType], buffer, methodReturnLength);
        
        if (autoAlloc || // If autoAlloc'd then we assume the returned object is the same as the alloc'd method (gets around placeholder problem)
            strcmp(methodName, "alloc") == 0 || // If this object was alloc, retain, copy then don't "auto retain"
            strcmp(methodName, "copy") == 0 || 
            strcmp(methodName, "retain") == 0 ||
            strcmp(methodName, "mutableCopy") == 0 ||
            strcmp(methodName, "allocWithZone") == 0 ||
            strcmp(methodName, "copyWithZone") == 0 ||
            strcmp(methodName, "mutableCopyWithZone") == 0) {
            
            ObjLua_Instance *returnedObjLuaInstance = (ObjLua_Instance *)lua_topointer(L, -1);
            [returnedObjLuaInstance->objcInstance release];
        }
        
        free(buffer);
    }
    
    return 1;
}