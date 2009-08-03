//
//  ObjLua_Class.m
//  Lua
//
//  Created by ProbablyInteractive on 5/20/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "ObjLua_Class.h"
#import "ObjLua_Instance.h"
#import "ObjLua_Helpers.h"

#import "lua.h"
#import "lauxlib.h"

static lua_State *gL;

static const struct luaL_Reg MetaMethods[] = {
    {"__index", __index},
    {"__call", __call},
    {NULL, NULL}
};

static const struct luaL_Reg Methods[] = {
    {NULL, NULL}
};

int luaopen_objlua_class(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    gL = L;
    
    luaL_newmetatable(L, OBJLUA_CLASS_METATABLE_NAME);
    luaL_register(L, NULL, MetaMethods);
    luaL_register(L, OBJLUA_CLASS_METATABLE_NAME, Methods);    

    // Set the metatable for the module
    luaL_getmetatable(L, OBJLUA_CLASS_METATABLE_NAME);
    lua_setmetatable(L, -2);
    
    END_STACK_MODIFY(L, 0)
    
    return 1;
}

static void forwardInvocation(id self, SEL _cmd, NSInvocation *invocation) {
    BEGIN_STACK_MODIFY(gL);
    objlua_instance_push_function(gL, self, [invocation selector]);
    
    if (lua_isnil(gL, -1)) {
        lua_pop(gL, 1);        
        return;
    }
    else {
        objlua_instance_push_userdata(gL, self);
        if (lua_pcall(gL, 1, 0, 0)) {
            const char* error_string = lua_tostring(gL, -1);
            NSLog(@"Problem calling Lua function '%s' on userdata (%s)", [invocation selector], error_string);
        }
        
        // should set return value?
    }
    
    END_STACK_MODIFY(gL, 0)
    
    return;
}

static NSMethodSignature *methodSignatureForSelector(id self, SEL _cmd, SEL selector) {
    struct objc_super super;
    super.receiver = self;
#if TARGET_IPHONE_SIMULATOR
    super.class = [self superclass];
#else
    super.super_class = [self superclass];
#endif
    
    NSMethodSignature *signature = objc_msgSendSuper(&super, _cmd, selector);
    
    if (signature) return signature;

    objlua_instance_push_function(gL, self, selector);
    
    if (lua_isnil(gL, -1)) {
        lua_pop(gL, 1);        
        return nil;
    }
    else {
        lua_pop(gL, 1);
    }
    
    int argCount = 0;
    
    const char *selectorName = sel_getName(selector);
    for (int i = 0; selectorName[i]; i++) if (selectorName[i] == ':') argCount++;
    
    int typeStringSize = 4 + argCount; // 1 return value, 2 extra chars for the hidden args (self, _cmd) 1 extra for \0
    char *typeString = alloca(typeStringSize);
    memset(typeString, '@', typeStringSize);
    typeString[2] = ':';
    typeString[typeStringSize - 1] = '\0';
    signature = [NSMethodSignature signatureWithObjCTypes:typeString];
    
    return signature;
}

// Finds an obj-c class
static int __index(lua_State *L) {
    const char *className = luaL_checkstring(L, 2);
    objlua_instance_create(L, objc_getClass(className), YES);
    
    return 1;
}

// Creates a new obj-c class
static int __call(lua_State *L) {   
    const char *className = luaL_checkstring(L, 2);
    Class class = objc_getClass(className);
    
    if (class) { // Class should not already exist!
        luaL_error(L, "Trying to create a class named '%s', but one already exists.", className);
    }
    else {
        Class superClass;    
        if (lua_isuserdata(L, 3)) {
            ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, 2, OBJLUA_INSTANCE_METATABLE_NAME);
            superClass = objLuaInstance->objcInstance;
        }
        else {
            const char *superClassName = luaL_checkstring(L, 3);    
            superClass = objc_getClass(superClassName);
        }
        
        class = objc_allocateClassPair(superClass, className, 0);
        objc_registerClassPair(class);        
        
        class_addMethod(class, @selector(methodSignatureForSelector:), (IMP)methodSignatureForSelector, "@@::");
        class_addMethod(class, @selector(forwardInvocation:), (IMP)forwardInvocation, "v@:@");
    }
        
    objlua_instance_create(L, class, YES);
    
    return 1;
}