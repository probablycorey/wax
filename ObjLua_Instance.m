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
#import "lobject.h"

static lua_State *gL;

static const struct luaL_Reg MetaMethods[] = {
    {"__index", __index},
    {"__newindex", __newindex},
    {"__gc", __gc},
    {"__tostring", __tostring},
    {"__call", __call},
    {NULL, NULL}
};

static const struct luaL_Reg Methods[] = {
    {"set_protocols", set_protocols},
    {NULL, NULL}
};

int luaopen_objlua_instance(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    gL = L;
    luaL_newmetatable(L, OBJLUA_INSTANCE_METATABLE_NAME);
    luaL_register(L, NULL, MetaMethods);
    luaL_register(L, OBJLUA_INSTANCE_METATABLE_NAME, Methods);    
    
    END_STACK_MODIFY(L, 0);
    
    return 1;
}


// Creates userdata object for obj-c instance/class and pushes it onto the stack
ObjLua_Instance *objlua_instance_create(lua_State *L, id objcInstance, BOOL isClass) {
    // Does user data already exist?
    objlua_instance_push_userdata(L, objcInstance);
   
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

// First look in the object's userdata for the function, then look in the object's class's userdata
BOOL objlua_instance_push_function(lua_State *L, id self, SEL selector) {
    BEGIN_STACK_MODIFY(L)
    
    objlua_instance_push_userdata(L, self);
    if (lua_isnil(L, -1)) {
        END_STACK_MODIFY(L, 0);
        return NO; // userdata doesn't exist
    }
    
    lua_getfenv(L, -1);
    objlua_push_method_name_from_selector(L, selector);
    lua_rawget(L, -2);
    
    BOOL result = YES;
    
    if (lua_isnil(L, -1)) { // function not found in userdata
        if ([self class] == self) result = NO; // End of the line bub, can't go any further up
        else result = objlua_instance_push_function(L, [self class], selector);
    }
    
    END_STACK_MODIFY(L, 1);
    
    return result;
}

void objlua_instance_push_userdata(lua_State *L, id object) {
    BEGIN_STACK_MODIFY(L);
    
    luaL_getmetatable(L, OBJLUA_INSTANCE_METATABLE_NAME);
    lua_getfield(L, -1, "__userdata");
    
    if (lua_isnil(L, -1)) { // __userdata table does not exist yet 
        lua_remove(L, -2); // remove metadata table
    }
    else {
        lua_pushlightuserdata(L, object);    
        lua_rawget(L, -2);
        lua_remove(L, -2); // remove __userdata table
        lua_remove(L, -2); // remove metadata table
    }
    
    END_STACK_MODIFY(L, 1);
}

static int __index(lua_State *L) {
    ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);

    // Check instance userdata
    lua_getfenv(L, -2);
    lua_pushvalue(L, -2);
    lua_rawget(L, 3);

    // Check instance's class userdata
    if (lua_isnil(L, -1) && !objLuaInstance->isClass) {
        lua_pop(L, 1);
        
        objlua_instance_push_userdata(L, [objLuaInstance->objcInstance class]);
        
        // If there is no userdata for this instance's class, then leave the nil on the stack and don't so anything else
        if (!lua_isnil(L, -1)) {
            lua_getfenv(L, -1);
            lua_pushvalue(L, 2);
            lua_rawget(L, -2);
            lua_remove(L, -2); // Get rid of the userdata env
            lua_remove(L, -2); // Get rid of the userdata
        }        
    }
    
    // TODO: This init check is a hack... only needed to get super to work. ADD SUPER TO USERDATA!
    BOOL isInitMethod = objLuaInstance->isClass && strncmp(lua_tostring(L, 2), "init", 4) == 0;
    if (lua_isnil(L, -1) || isInitMethod ) {
        // Couldn't find that in the userdata environment table
        // OR if the init* method is overridden, then make sure we call this as a closure (BECAUSE WE DO MAGIC/SECRET ALLOCS!)

        SEL selector = objlua_selector_for_instance(objLuaInstance, lua_tostring(L, 2), isInitMethod);
        if (selector) {
            // If the class has a method with this name, push as a closure
            lua_settop(L, 2);
            lua_pushstring(L, sel_getName(selector));
            lua_replace(L, 2); // Replace lua method name with obj-c selector name
            lua_pushcclosure(L, method_closure, 2);
        }
    }
    
    return 1;
}

static int __newindex(lua_State *L) {
    ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);
    
    // If we can't add it to the obj-c object, then add it to the userdata
    if (lua_type(L, 3) == LUA_TFUNCTION) {
        override_method(L, objLuaInstance);
    }
    
    // Add value to the userdata's environment table
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
    lua_pushstring(L, [[NSString stringWithFormat:@"(0x%x => 0x%x) %@", objLuaInstance, objLuaInstance->objcInstance, objLuaInstance->objcInstance] UTF8String]);
    
    return 1;
}

static int __call(lua_State *L) {
    luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);
    void *rawObject = objlua_to_objc(L, @encode(id), 2, nil);
    objlua_instance_create(L, *(id *)rawObject, NO);
    free(rawObject);
    
    return 1;
}

int set_protocols(lua_State *L) {
    ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);
    
    if (!objLuaInstance->isClass) {
        luaL_error(L, "ERROR: Can only set a protocol on a class for now");
        return 0;
    }
    
    for (int i = 2; i <= lua_gettop(L); i++) {
        const char *protocol_name = lua_tostring(L, i);
        Protocol *protocol = objc_getProtocol(protocol_name);
        if (!protocol) luaL_error(L, "Could not find protocol named '%s'", protocol);
        class_addProtocol(objLuaInstance->objcInstance, protocol);
    }
    
    return 0;
}

static int method_closure(lua_State *L) {    
    ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, lua_upvalueindex(1), OBJLUA_INSTANCE_METATABLE_NAME);
    const char *selectorName = luaL_checkstring(L, lua_upvalueindex(2));
    SEL selector = sel_getUid(selectorName);
    BOOL autoAlloc = NO;
    
    if (objLuaInstance->isClass && strncmp(selectorName, "init", 4) == 0) {
        // If init is called on a class, allocate it.
        // This is done to get around the placeholder stuff the foundation class uses
        objLuaInstance = objlua_instance_create(L, [objLuaInstance->objcInstance alloc], NO);
        autoAlloc = YES;
    }
    
    NSMethodSignature *signature = [objLuaInstance->objcInstance methodSignatureForSelector:selector];
    if (!signature) {
        const char *className = [NSStringFromClass([objLuaInstance->objcInstance class]) UTF8String];
        luaL_error(L, "'%s' has no method selector '%s'", className, selectorName);
    }
    
    NSInvocation *invocation = nil;
    invocation = [NSInvocation invocationWithMethodSignature:signature];
        
    [invocation setTarget:objLuaInstance->objcInstance];
    [invocation setSelector:selector];
    
    int objcArgumentCount = [signature numberOfArguments] - 2; // skip the first two because self and _cmd are always the first two
    
    void **arguements = calloc(sizeof(void*), objcArgumentCount);
    for (int i = 0; i < objcArgumentCount; i++) {
        arguements[i] = objlua_to_objc(L, [signature getArgumentTypeAtIndex:i + 2], i + 1, nil);
        [invocation setArgument:arguements[i] atIndex:i + 2];
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
            
        objlua_from_objc(L, [signature methodReturnType], buffer);
        
        if (autoAlloc || // If autoAlloc'd then we assume the returned object is the same as the alloc'd method (gets around placeholder problem)
            strcmp(selectorName, "alloc") == 0 || // If this object was alloc, retain, copy then don't "auto retain"
            strcmp(selectorName, "copy") == 0 || 
            strcmp(selectorName, "retain") == 0 ||
            strcmp(selectorName, "mutableCopy") == 0 ||
            strcmp(selectorName, "allocWithZone") == 0 ||
            strcmp(selectorName, "copyWithZone") == 0 ||
            strcmp(selectorName, "mutableCopyWithZone") == 0) {
            
            if (lua_isuserdata(L, -1)) {
                ObjLua_Instance *returnedObjLuaInstance = (ObjLua_Instance *)lua_topointer(L, -1);
                [returnedObjLuaInstance->objcInstance release];
            }
        }
        
        free(buffer);
    }
    
    return 1;
}

static int super_closure(lua_State *L) {
    ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, lua_upvalueindex(1), OBJLUA_INSTANCE_METATABLE_NAME);
    const char *selectorName = luaL_checkstring(L, lua_upvalueindex(2));    
    SEL selector = sel_getUid(selectorName);
    
    if (selector) {
        // Super Swizzle
        id instance = objLuaInstance->objcInstance;

        Method selfMethod = class_getInstanceMethod([instance class], selector);
        Method superMethod = class_getInstanceMethod([instance superclass], selector);        
        IMP selfMethodImp = method_getImplementation(selfMethod);        
        
        if (superMethod) {
            IMP superMethodImp = method_getImplementation(superMethod);
            method_setImplementation(selfMethod, superMethodImp);
        }
        
        method_closure(L);
        
        if (superMethod) method_setImplementation(selfMethod, selfMethodImp);
    }
    else {
        method_closure(L);
    }

    return 1;
}

static int userdata_pcall(lua_State *L, id self, SEL selector, va_list args) {
    BEGIN_STACK_MODIFY(L)    
    
    // Find the function... could be in the object or in the class
    if (!objlua_instance_push_function(L, self, selector)) goto error; // function not found in userdata...
    
    // Push userdata as the first argument
    objlua_from_objc_instance(L, self);
    if (lua_isnil(L, -1)) goto error;
    
    // add a secret "super" closure to this function This adds it everywhere... at it to the userdata!
    lua_getfenv(L, -2);      
    objlua_instance_create(L, self, NO); 
    lua_pushstring(L, sel_getName(selector));
    lua_pushcclosure(L, super_closure, 2);
    lua_setfield(L, -2, "super");
    lua_pop(L, 1); // Pop env table
            
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    int nargs = [signature numberOfArguments] - 1; // Don't send in the _cmd argument, only self
    int nresults = [signature methodReturnLength] ? 1 : 0;
        
    for (int i = 2; i < [signature numberOfArguments]; i++) { // start at 2 because to skip the automatic self and _cmd arugments
        const char *type = [signature getArgumentTypeAtIndex:i];
        int size = objlua_from_objc(L, type, args);
        args += size; // HACK! Since va_arg requires static type, I manually increment the args
    }

    lua_pushstring(L, sel_getName(selector));
    lua_pushstring(L, object_getClassName(self));
    lua_pushcclosure(L, objlua_error_closure, 2);
    int errorFunctionIndex = -1 - nargs - 1; // move error function to the top
    lua_insert(L, errorFunctionIndex); 
    
    if (lua_pcall(L, nargs, nresults, errorFunctionIndex)) { // Userdata will allways be the first object sent to the function
        goto error;
    }
    
    END_STACK_MODIFY(L, nresults);
    return nresults;
    
error:
    END_STACK_MODIFY(L, 0);
    return -1;
}

#define OBJLUA_METHOD(_type_) \
OBJLUA_METHOD_DEFINITION(_type_) { \
va_list args; \
va_start(args, _cmd); \
va_list args_copy; \
va_copy(args_copy, args); \
/* Grab the static L... this is a hack */ \
lua_State *L = gL; \
int result = userdata_pcall(L, self, _cmd, args_copy); \
va_end(args_copy); \
va_end(args); \
if (result == -1) { \
    luaL_error(L, "ERROR: Exiting app!"); \
} \
else if (result == 1) { \
    NSMethodSignature *signature = [self methodSignatureForSelector:_cmd]; \
    _type_ *pReturnValue = (_type_ *)objlua_to_objc(L, [signature methodReturnType], -1, nil); \
    _type_ returnValue = *pReturnValue; \
    free(pReturnValue); \
    return returnValue; \
} \
\
return (_type_)0; \
}

static BOOL override_method(lua_State *L, ObjLua_Instance *objLuaInstance) {
    BEGIN_STACK_MODIFY(L);
    
    BOOL success = NO;
    const char *methodName = lua_tostring(L, 2);
    SEL selector = objlua_selector_for_instance(objLuaInstance, methodName, objLuaInstance->isClass);
    Class class = [objLuaInstance->objcInstance class];
    const char *type_description = nil;
    
    Method method = class_getInstanceMethod(class, selector);
    
    if (method) { // Is method defined in the superclass?
        type_description = method_getTypeEncoding(method);
    }
    else { // Does this object implement a protocol with this method?
        uint count;
        Protocol **protocols = class_copyProtocolList(class, &count);
        
        SEL *posibleSelectors = &objlua_selectors_for_name(methodName).selectors[0];
        
        for (int i = 0; !type_description && i < count; i++) {
            Protocol *protocol = protocols[i];
            struct objc_method_description m_description;
            
            for (int j = 0; !type_description && j < 2; j++) {
                selector = posibleSelectors[j];
                
                m_description = protocol_getMethodDescription(protocol, selector, YES, YES);
                if (!m_description.name) m_description = protocol_getMethodDescription(protocol, selector, NO, YES); // Check if it is not a "required" method
                
                if (&m_description) type_description = m_description.types;
            }
        }
        
        free(protocols);
    }
    
    if (type_description) { // Matching method found! Create an Obj-C method on the 
        type_description = objlua_remove_protocol_encodings(type_description);
        IMP imp;
        switch (type_description[0]) {
            case OBJLUA_TYPE_VOID:
            case OBJLUA_TYPE_ID:
                imp = (IMP)OBJLUA_METHOD_NAME(id);
                break;
                
            case OBJLUA_TYPE_CHAR:
            case OBJLUA_TYPE_INT:
            case OBJLUA_TYPE_SHORT:
            case OBJLUA_TYPE_UNSIGNED_CHAR:
            case OBJLUA_TYPE_UNSIGNED_INT:
            case OBJLUA_TYPE_UNSIGNED_SHORT:   
                imp = (IMP)OBJLUA_METHOD_NAME(int);
                break;            
                
            case OBJLUA_TYPE_LONG:
            case OBJLUA_TYPE_LONG_LONG:
            case OBJLUA_TYPE_UNSIGNED_LONG:
            case OBJLUA_TYPE_UNSIGNED_LONG_LONG:
                imp = (IMP)OBJLUA_METHOD_NAME(long);
                
            case OBJLUA_TYPE_FLOAT:
                imp = (IMP)OBJLUA_METHOD_NAME(float);
                break;
                
            case OBJLUA_TYPE_C99_BOOL:
                imp = (IMP)OBJLUA_METHOD_NAME(BOOL);
                break;
                
            default:   
                luaL_error(L, "Can't handle method with return type %c", type_description[0]);
                break;
        }
        
        success = class_addMethod(class, selector, imp, type_description);
    }
    else {
        NSLog(@"No method name '%s' found in superclass or protocols", methodName);
    }
    
    END_STACK_MODIFY(L, 1);
    
    return success;
}

// Expects the objects userdata to be on the top of the stack
OBJLUA_METHOD(id)
OBJLUA_METHOD(int)
OBJLUA_METHOD(long)
OBJLUA_METHOD(float)
OBJLUA_METHOD(BOOL) 