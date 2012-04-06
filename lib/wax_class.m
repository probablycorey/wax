//
//  wax_class.m
//  Lua
//
//  Created by ProbablyInteractive on 5/20/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "wax_class.h"

#import "wax.h"
#import "wax_instance.h"
#import "wax_helpers.h"

#import "lua.h"
#import "lauxlib.h"

static int __index(lua_State *L);
static int __call(lua_State *L);

static int addProtocols(lua_State *L);
static int name(lua_State *L);
static id alloc(id self, SEL _cmd);
static id allocWithZone(id self, SEL _cmd, NSZone *);
static id valueForUndefinedKey(id self, SEL cmd, NSString *key);
static void setValueForUndefinedKey(id self, SEL cmd, id value, NSString *key);

static const struct luaL_Reg MetaMethods[] = {
    {"__index", __index},
    {"__call", __call},
    {NULL, NULL}
};

static const struct luaL_Reg Methods[] = {
    {"addProtocols", addProtocols},
    {"name", name},
    {NULL, NULL}
};

int luaopen_wax_class(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    luaL_newmetatable(L, WAX_CLASS_METATABLE_NAME);
    luaL_register(L, NULL, MetaMethods);
    luaL_register(L, WAX_CLASS_METATABLE_NAME, Methods);    

    // Set the metatable for the module
    luaL_getmetatable(L, WAX_CLASS_METATABLE_NAME);
    lua_setmetatable(L, -2);
    
    END_STACK_MODIFY(L, 0)
    
    return 1;
}


// Finds an ObjC class
static int __index(lua_State *L) {
    const char *className = luaL_checkstring(L, 2);
    Class klass = objc_getClass(className);
    if (klass) {
        wax_instance_create(L, klass, YES);
    }
    else {
        lua_pushnil(L);
    }
    
    return 1;
}

// Creates a new ObjC class
static int __call(lua_State *L) {   
    const char *className = luaL_checkstring(L, 2);
    Class klass = objc_getClass(className);
    
    if (!klass) {
        Class superClass;    
        if (lua_isuserdata(L, 3)) {
            wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 3, WAX_INSTANCE_METATABLE_NAME);
            superClass = instanceUserdata->instance;
        }
        else if (lua_isnoneornil(L, 3)) {
            superClass = [NSObject class];
        }
        else {
            const char *superClassName = luaL_checkstring(L, 3);
            superClass = objc_getClass(superClassName);
        }
        
        if (!superClass) {
            luaL_error(L, "Failed to create '%s'. Unknown superclass \"%s\" received.", className, luaL_checkstring(L, 3));
        }
        
        klass = objc_allocateClassPair(superClass, className, 0);
        NSUInteger size;
        NSUInteger alignment;
        NSGetSizeAndAlignment("*", &size, &alignment);
        class_addIvar(klass, WAX_CLASS_INSTANCE_USERDATA_IVAR_NAME, size, alignment, "*"); // Holds a reference to the lua userdata
        objc_registerClassPair(klass);        

        // Make Key-Value complient
        class_addMethod(klass, @selector(setValue:forUndefinedKey:), (IMP)setValueForUndefinedKey, "v@:@@");
        class_addMethod(klass, @selector(valueForUndefinedKey:), (IMP)valueForUndefinedKey, "@@:@");        

        id metaclass = object_getClass(klass);
        
        // So objects created in ObjC will get an associated lua object
        // Store the original allocWithZone implementation in case something secret goes on in there. 
        // Calls to `alloc` always are end up calling `allocWithZone:` so we don't bother handling alloc here.
        Method m = class_getInstanceMethod(metaclass, @selector(allocWithZone:));
        
        // If we the method has already been swizzled (by the class's super, then
        // just leave it up to the super!
        if (method_getImplementation(m) != (IMP)allocWithZone) {
            class_addMethod(metaclass, @selector(wax_originalAllocWithZone:), method_getImplementation(m), method_getTypeEncoding(m));
            class_addMethod(metaclass, @selector(allocWithZone:), (IMP)allocWithZone, "@@:^{_NSZone=}");
        }
    }
        
    wax_instance_create(L, klass, YES);
    
    return 1;
}

static int addProtocols(lua_State *L) {
    wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 1, WAX_INSTANCE_METATABLE_NAME);
    
    if (!instanceUserdata->isClass) {
        luaL_error(L, "ERROR: Can only set a protocol on a class (You are trying to set one on an instance)");
        return 0;
    }
    
    for (int i = 2; i <= lua_gettop(L); i++) {
        const char *protocolName = luaL_checkstring(L, i);
        Protocol *protocol = objc_getProtocol(protocolName);
        if (!protocol) luaL_error(L, "Could not find protocol named '%s'\nHint: Sometimes the runtime cannot automatically find a protocol. Try adding it (via xCode) to the file ProtocolLoader.h", protocolName);
        class_addProtocol(instanceUserdata->instance, protocol);
    }
    
    return 0;
}

static int name(lua_State *L) {
    wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 1, WAX_INSTANCE_METATABLE_NAME);
    lua_pushstring(L, [NSStringFromClass([instanceUserdata->instance class]) UTF8String]);
    return 1;
}

static id allocWithZone(id self, SEL _cmd, NSZone *zone) {
    lua_State *L = wax_currentLuaState(); 
    BEGIN_STACK_MODIFY(L);

    id instance = [self wax_originalAllocWithZone:zone];
    object_setInstanceVariable(instance, WAX_CLASS_INSTANCE_USERDATA_IVAR_NAME, @"YEAP");
    
    END_STACK_MODIFY(L, 0);
    
    return instance;
}


static void setValueForUndefinedKey(id self, SEL cmd, id value, NSString *key) {
    lua_State *L = wax_currentLuaState();
    
    BEGIN_STACK_MODIFY(L);
    
    wax_instance_pushUserdata(L, self);
    wax_fromObjc(L, "@", &value);
    lua_setfield(L, -2, [key UTF8String]);
    
    END_STACK_MODIFY(L, 0);
}

static id valueForUndefinedKey(id self, SEL cmd, NSString *key) {
    lua_State *L = wax_currentLuaState();    
    id result = nil;
    
    BEGIN_STACK_MODIFY(L);
    
    wax_instance_pushUserdata(L, self);
    lua_getfield(L, -1, [key UTF8String]);
    
    id *keyValue = wax_copyToObjc(L, "@", -1, nil);
    result = *keyValue;
    free(keyValue);
    
    END_STACK_MODIFY(L, 0);
    
    return result;
}