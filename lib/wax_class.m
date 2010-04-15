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

static const struct luaL_Reg MetaMethods[] = {
    {"__index", __index},
    {"__call", __call},
    {NULL, NULL}
};

static const struct luaL_Reg Methods[] = {
    {"addProtocols", addProtocols},
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

static id alloc(id self, SEL _cmd) {    
    lua_State *L = wax_currentLuaState(); 

    BEGIN_STACK_MODIFY(L);

    id instance = class_createInstance(self, 0);
    wax_instance_userdata *waxInstance = wax_instance_create(L, instance, NO);
    object_setInstanceVariable(instance, WAX_CLASS_INSTANCE_USERDATA_IVAR_NAME, waxInstance);
    
    END_STACK_MODIFY(L, 0);
    
    return instance;
}

static void forwardInvocation(id self, SEL _cmd, NSInvocation *invocation) {
    lua_State *L = wax_currentLuaState();
    
    BEGIN_STACK_MODIFY(L);
    wax_instance_pushFunction(L, self, [invocation selector]);
    
    if (lua_isnil(L, -1)) {
        END_STACK_MODIFY(L, 0)   
        return;
    }
    else {
        if (![[NSThread currentThread] isEqual:[NSThread mainThread]]) NSLog(@"FORWARD INVOCATION: OH NO SEPERATE THREAD");
        wax_instance_pushUserdata(L, self);

        NSMethodSignature *signature = [invocation methodSignature];
        int argumentCount = [signature numberOfArguments];                
        
        for (int i = 2; i < argumentCount; i++) { // Skip the hidden seld and _cmd arguements (self already added above)
            const char *typeDescription = [signature getArgumentTypeAtIndex:i];
            int argSize = wax_sizeOfTypeDescription(typeDescription);

            void *buffer = malloc(argSize);
            [invocation getArgument:buffer atIndex:i];
            wax_fromObjc(L, typeDescription, buffer);
            free(buffer);
        }
                
        if (wax_pcall(L, argumentCount - 1, 1)) { // Subtract 1 from argumentCount because we don't want to send the hidden _cmd arguement
            const char* error_string = lua_tostring(L, -1);
            
            printf("Problem calling Lua function '%s' on userdata.\n%s", sel_getName([invocation selector]), error_string);
        }

        void *returnValue = wax_copyToObjc(L, [signature methodReturnType], -1, nil);
        [invocation setReturnValue:returnValue];
        free(returnValue);
    }
    
    END_STACK_MODIFY(L, 0)
    
    return;
}

// Used for both methodSignatureForSelector and instnanceMethodSignatureForSelector
static NSMethodSignature *methodSignatureForSelector(id self, SEL _cmd, SEL selector) {
    lua_State *L = wax_currentLuaState();
    BEGIN_STACK_MODIFY(L)    
    
    NSMethodSignature *signature = nil;
    
    if (self == [self class]) { // it's a class, not an instance
        signature = objc_msgSend([self superclass], _cmd, selector);
    }
    else {
        struct objc_super super;
        super.receiver = self;
#if TARGET_IPHONE_SIMULATOR
        super.class = [self superclass];
#else
        super.super_class = [self superclass];
#endif
        
        signature = objc_msgSendSuper(&super, _cmd, selector);
    }
    
    if (signature) return signature;
    
    wax_instance_pushFunction(L, self, selector);
    
    if (lua_isnil(L, -1)) {
        END_STACK_MODIFY(L, 0)
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
    
    END_STACK_MODIFY(L, 0)
    
    return signature;
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

// Finds an obj-c class
static int __index(lua_State *L) {
    const char *className = luaL_checkstring(L, 2);
    Class class = objc_getClass(className);
    if (class) {
        wax_instance_create(L, class, YES);
    }
    else {
        lua_pushnil(L);
    }
    
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
            luaL_error(L, "Failed to create '%s'. Unknown superclass received.", className);
        }
        
        class = objc_allocateClassPair(superClass, className, 0);
        NSUInteger size;
        NSUInteger alignment;
        NSGetSizeAndAlignment("*", &size, &alignment);
        class_addIvar(class, WAX_CLASS_INSTANCE_USERDATA_IVAR_NAME, size, alignment, "*"); // Holds a reference to the lua userdata
        objc_registerClassPair(class);        

//        IMP origMethodSignatureForSelector = class_getMethodImplementation(class, @selector(methodSignatureForSelector));
//        class_addMethod(class, @selector(origMethodSignatureForSelector:), origMethodSignatureForSelector, "@@::");
        
        // These methods need to be added because of delegates
//        class_addMethod(class, @selector(methodSignatureForSelector:), (IMP)methodSignatureForSelector, "@@::");
//        class_addMethod(class, @selector(forwardInvocation:), (IMP)forwardInvocation, "v@:@");

        // Make Key-Value complient
        class_addMethod(class, @selector(setValue:forUndefinedKey:), (IMP)setValueForUndefinedKey, "v@:@@");
        class_addMethod(class, @selector(valueForUndefinedKey:), (IMP)valueForUndefinedKey, "@@:@");        

        id metaclass = object_getClass(class);        

        class_addMethod(metaclass, @selector(alloc), (IMP)alloc, "@@:");
//        class_addMethod(metaclass, @selector(instanceMethodSignatureForSelector:), (IMP)methodSignatureForSelector, "@@::");
        
        // Allow obj-c to talk to a waxClass' class methods
//        class_addMethod(metaclass, @selector(methodSignatureForSelector:), (IMP)methodSignatureForSelector, "@@::");
//        class_addMethod(metaclass, @selector(forwardInvocation:), (IMP)forwardInvocation, "v@:@");
    }
        
    wax_instance_create(L, class, YES);
    
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
        if (!protocol) luaL_error(L, "Could not find protocol named '%s'\nHint: Sometimes the runtime cannot automatically find a protocol. Try adding it (via xCode) to file ProtocolLoader.h", protocolName);
        class_addProtocol(instanceUserdata->instance, protocol);
    }
    
    return 0;
}
