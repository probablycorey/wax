//
//  oink_class.m
//  Lua
//
//  Created by ProbablyInteractive on 5/20/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "oink_class.h"

#import "oink.h"
#import "oink_instance.h"
#import "oink_helpers.h"

#import "lua.h"
#import "lauxlib.h"

static const struct luaL_Reg MetaMethods[] = {
    {"__index", __index},
    {"__call", __call},
    {NULL, NULL}
};

static const struct luaL_Reg Methods[] = {
    {NULL, NULL}
};

int luaopen_oink_class(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    luaL_newmetatable(L, OINK_CLASS_METATABLE_NAME);
    luaL_register(L, NULL, MetaMethods);
    luaL_register(L, OINK_CLASS_METATABLE_NAME, Methods);    

    // Set the metatable for the module
    luaL_getmetatable(L, OINK_CLASS_METATABLE_NAME);
    lua_setmetatable(L, -2);
    
    END_STACK_MODIFY(L, 0)
    
    return 1;
}

static void forwardInvocation(id self, SEL _cmd, NSInvocation *invocation) {
    lua_State *L = oink_currentLuaState();
    
    BEGIN_STACK_MODIFY(L);
    oink_instance_pushFunction(L, self, [invocation selector]);
    
    if (lua_isnil(L, -1)) {
        lua_pop(L, 1);        
        return;
    }
    else {
        if (![[NSThread currentThread] isEqual:[NSThread mainThread]]) NSLog(@"FORWARD INVOCATION: OH NO SEPERATE THREAD");
        oink_instance_pushUserdata(L, self);

        NSMethodSignature *signature = [invocation methodSignature];
        int argumentCount = [signature numberOfArguments];
        
        for (int i = 2; i < argumentCount; i++) { // Skip the hidden seld and _cmd arguements (self already added above)
            const char *typeDescription = [signature getArgumentTypeAtIndex:i];
            int argSize = oink_sizeOfTypeDescription(typeDescription);

            void *buffer = malloc(argSize);
            [invocation getArgument:buffer atIndex:i];
            oink_fromObjc(L, typeDescription, buffer);
            free(buffer);
        }
        
        if (lua_pcall(L, argumentCount - 1, 1, 0)) { // Subtract 1 from argumentCount because we don't want to send the hidden _cmd arguement
            const char* error_string = lua_tostring(L, -1);
            NSLog(@"Problem calling Lua function '%s' on userdata (%s)", [invocation selector], error_string);
        }

        void *returnValue = oink_copyToObjc(L, [signature methodReturnType], -1, nil);
        [invocation setReturnValue:returnValue];
        free(returnValue);
    }
    
    END_STACK_MODIFY(L, 0)
    
    return;
}

static NSMethodSignature *methodSignatureForSelector(id self, SEL _cmd, SEL selector) {
    lua_State *L = oink_currentLuaState();
    
    struct objc_super super;
    super.receiver = self;
#if TARGET_IPHONE_SIMULATOR
    super.class = [self superclass];
#else
    super.super_class = [self superclass];
#endif
    
    NSMethodSignature *signature = objc_msgSendSuper(&super, _cmd, selector);
    
    if (signature) return signature;

    oink_instance_pushFunction(L, self, selector);
    
    if (lua_isnil(L, -1)) {
        lua_pop(L, 1);        
        return nil;
    }
    else {
        lua_pop(L, 1);
    }
    
    int argCount = 0;
    
    const char *selectorName = sel_getName(selector);
    for (int i = 0; selectorName[i]; i++) if (selectorName[i] == ':') argCount++;
    
    int typeStringSize = 4 + argCount; // 1 return value, 2 extra chars for the hidden args (self, _cmd) and 1 extra for \0
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
    oink_instance_create(L, objc_getClass(className), YES);
    
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
            oink_instance_userdata *instanceUserdata = (oink_instance_userdata *)luaL_checkudata(L, 3, OINK_INSTANCE_METATABLE_NAME);
            superClass = instanceUserdata->instance;
        }
        else {
            const char *superClassName = luaL_checkstring(L, 3);    
            superClass = objc_getClass(superClassName);
        }
        
        if (!superClass) {
            luaL_error(L, "Failed to create '%s'. Unknown superclass received.", className);
        }
        
        class = objc_allocateClassPair(superClass, className, 0);
        objc_registerClassPair(class);        
        
        class_addMethod(class, @selector(methodSignatureForSelector:), (IMP)methodSignatureForSelector, "@@::");
        class_addMethod(class, @selector(forwardInvocation:), (IMP)forwardInvocation, "v@:@");
    }
        
    oink_instance_create(L, class, YES);
    
    return 1;
}