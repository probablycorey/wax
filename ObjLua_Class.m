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
    {NULL, NULL}
};

static const struct luaL_Reg Methods[] = {
    {"new", new},
    {"get", get},
    {"methods", methods},
    {NULL, NULL}
};

int luaopen_objlua_class(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    gL = L;
    
    luaL_newmetatable(L, OBJLUA_CLASS_METATABLE_NAME);
    luaL_register(L, NULL, MetaMethods);
    luaL_register(L, "objlua.class", Methods);    

    END_STACK_MODIFY(L, 0);
    
    return 1;
}

// I don't like the name of this!
static int get(lua_State *L) {
    const char *rawClassName = luaL_checkstring(L, 1);
    objlua_instance_create(L, objc_getClass(rawClassName), YES);
        
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
    
    END_STACK_MODIFY(gL, 0);
    
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

static int new(lua_State *L) {
    const char *rawClassName = luaL_checkstring(L, 1);
    Class class = objc_getClass(rawClassName);
  
    Class superClass;    
    if (lua_isuserdata(L, 2)) {
        ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, 2, OBJLUA_INSTANCE_METATABLE_NAME);
        superClass = objLuaInstance->objcInstance;
    }
    else {
        const char *rawSuperClassName = luaL_checkstring(L, 2);    
        superClass = objc_getClass(rawSuperClassName);
    }
    
    if (!class) {
        class = objc_allocateClassPair(superClass, rawClassName, 0);
        objc_registerClassPair(class);        
        
        class_addMethod(class, @selector(methodSignatureForSelector:), (IMP)methodSignatureForSelector, "@@::");
        class_addMethod(class, @selector(forwardInvocation:), (IMP)forwardInvocation, "v@:@");
    }     
        
    objlua_instance_create(L, class, YES);
    
    return 1;
}

static int methods(lua_State *L) {
    Class class;
    if (lua_isuserdata(L, 1)) {
        ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);
        class = objLuaInstance->objcInstance;
    }
    else {
        class = objc_getClass(luaL_checkstring(L, 1));
    }
    
    uint count;
    Method *methods = class_copyMethodList(class, &count);
    
    
    lua_newtable(L);
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        lua_pushnumber(L, i + 1);
        lua_setfield(L, -2, sel_getName(method_getName(method)));
    }
    
    free(methods);
    
    return 1;
}
