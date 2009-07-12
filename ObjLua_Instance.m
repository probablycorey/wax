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
    {"__tostring", __tostring},
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

ObjLua_Instance *objlua_instance_create(lua_State *L, id objcInstance, BOOL isClass) {
    // Does user data already exist?
    push_userdata_for_instance(L, objcInstance);
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
    ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);

    lua_getfenv(L, 1);
    lua_pushvalue(L, 2);
    lua_rawget(L, 3);
    
    if (lua_isnil(L, -1) || (objLuaInstance->isClass && lua_type(L, -1) == LUA_TFUNCTION && strncmp(lua_tostring(L, 2), "init", 4) == 0)) {
        // Couldn't find that in the userdata environment table
        // OR if the init* method is overridden, then make sure we call this as a closure (BECAUSE INIT MAGIC ALLOCS!)

        lua_settop(L, 2);
        lua_pushcclosure(L, method_closure, 2);
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
    // TODO this function is too complicated... Strip it down! 
    ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, lua_upvalueindex(1), OBJLUA_INSTANCE_METATABLE_NAME);
    const char *methodName = luaL_checkstring(L, lua_upvalueindex(2));    
    
    BOOL autoAlloc = NO;
    
    if (objLuaInstance->isClass && strncmp(methodName, "init", 4) == 0) {
        // If init is called on a class, allocate it.
        // This is done to get around the placeholder stuff the foundation class uses
        objLuaInstance = objlua_instance_create(L, [objLuaInstance->objcInstance alloc], NO);
        // lua_replace(L, -3); TODO figure out why this was here!?!
        autoAlloc = YES;
    }
    
    NSMethodSignature *signature = nil;

    Objlua_selectors posibleSelectors = objlua_selector_from_method_name(methodName);    
    SEL selector;
    for (int i = 0; !signature && i < 2; i++) {
        selector = posibleSelectors.selectors[i];
        signature = [objLuaInstance->objcInstance methodSignatureForSelector:selector];
    }
    
    if (!signature) {
        const char *className = [NSStringFromClass([objLuaInstance->objcInstance class]) UTF8String];
        luaL_error(L, "'%s' has no method selector '%s'", className, methodName);
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

static int super_closure(lua_State *L) {
    ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, lua_upvalueindex(1), OBJLUA_INSTANCE_METATABLE_NAME);
    SEL selector = sel_getUid(lua_tostring(L, lua_upvalueindex(2)));
    
    struct objc_super self_super;
    self_super.receiver = objLuaInstance->objcInstance;
    self_super.class = [objLuaInstance->objcInstance superclass];
    
    NSMethodSignature *signature = [objLuaInstance->objcInstance methodSignatureForSelector:selector];
    
    float buffer[4];// = malloc([signature frameLength]);
    int objcArgumentCount = [signature numberOfArguments] - 2; // skip the first two because self and _cmd are always the first two
    
    int offset = 0;
    for (int i = 0; i < objcArgumentCount; i++) {
        int size;
        char **arg = objlua_to_objc(L, [signature getArgumentTypeAtIndex:i + 2], i + 1, &size);
        memcpy(buffer + offset, *arg, size);
        offset += size;
    }
//    CGRect r = CGRectMake(0, 100, 320, 300);
//    CGPoint *p = buffer;
    id return_value = objc_msgSendSuper(&self_super, selector, buffer);
//    free(buffer);
    
    objlua_from_objc_instance(L, return_value);
    
    return 1;
}

static int userdata_pcall(lua_State *L, id self, SEL selector, va_list args) {
    BEGIN_STACK_MODIFY(L)
    
    // Find the method... could be in the object or in the class
    if (!push_function_for_instance(L, self, selector)) goto error; // method does not exist...
    
    // add a secret "super" closure to this function
    lua_getfenv(L, -1);    
    objlua_instance_create(L, self, NO);
    lua_pushstring(L, sel_getName(selector));
    lua_pushcclosure(L, super_closure, 2);
    lua_setfield(L, -2, "super");
    lua_settop(L, -2); // Pop env table
    
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    int nargs = [signature numberOfArguments] - 1; // Don't send in the _cmd argument, only self
    int nresults = [signature methodReturnLength] ? 1 : 0;
    
    // Push userdata as the first argument
    objlua_from_objc_instance(L, self);
    if (lua_isnil(L, -1)) goto error;    
    
    for (int i = 2; i < [signature numberOfArguments]; i++) { // start at 2 because to skip the automatic self and _cmd arugments
        const char *type = [signature getArgumentTypeAtIndex:i];
        int size = objlua_from_objc(L, type, &args);
        args += size; // HACK! Since va_arg requires static type, I manually increment the args
    }
    
    if (lua_pcall(L, nargs, nresults, 0)) { // Userdata will allways be the first object sent to the function
        const char* error_string = lua_tostring(L, -1);
        NSLog(@"Pig Error: Problem calling Lua function '%@' on userdata (%s)", NSStringFromSelector(selector), error_string);
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
    luaL_error(L, "Could not call method '%s' on lua object for '%s'", sel_getName(_cmd), object_getClassName(self)); \
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
    Class class = [objLuaInstance->objcInstance class];
    const char *type_encoding = nil;
    
    Method method = nil;
    SEL selector;
    Objlua_selectors possible_selectors = objlua_selector_from_method_name(lua_tostring(L, 2));        
    for (int i = 0; !method && i < 2; i++) {
        selector = possible_selectors.selectors[i];
        method = class_getInstanceMethod(class, selector);
    }
    
    if (method) { // Is method defined in the superclass?
        type_encoding = method_getTypeEncoding(method);
    }
    else { // Does this object implement a protocol with this method?
        uint count;
        Protocol **protocols = class_copyProtocolList(class, &count);
        
        for (int i = 0; !type_encoding && i < count; i++) {
            Protocol *protocol = protocols[i];
            struct objc_method_description m_description;
            
            for (int j = 0; !type_encoding && j < 2; i++) {
                selector = possible_selectors.selectors[i];
                
                m_description = protocol_getMethodDescription(protocol, selector, YES, YES);
                if (!m_description.name) m_description = protocol_getMethodDescription(protocol, selector, NO, YES); // Check if it is not a "required" method
                
                if (&m_description) type_encoding = m_description.types;
            }
        }
        
        free(protocols);
    }
    
    if (type_encoding) { // Matching method found! Create an Obj-C method on the 
        type_encoding = objlua_remove_protocol_encodings(type_encoding);
        IMP imp;
        switch (type_encoding[0]) {
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
                luaL_error(L, "Can't handle method with return type %c", type_encoding[0]);
                break;
        }
        
        success = class_addMethod(class, selector, imp, type_encoding);
    }
    else {
        NSLog(@"No method name '%s' found in superclass or protocols", selector);
    }
    
    END_STACK_MODIFY(L, 1);
    
    return success;
}

// First look in the object's userdata for the function, then look in the object's class's userdata
BOOL push_function_for_instance(lua_State *L, id self, SEL selector) {
    BEGIN_STACK_MODIFY(L)
    
    push_userdata_for_instance(L, self);
    if (lua_isnil(L, -1)) {
        END_STACK_MODIFY(L, 0);
        return NO; // userdata doesn't exist does not exist...
    }
    
    lua_getfenv(L, -1);
    objlua_push_method_name_from_selector(L, selector);
    lua_rawget(L, -2);
    
    BOOL result = YES;
    
    if (lua_isnil(L, -1)) { // method does not exist...
        if ([self class] == self) result = NO; // End of the line bub, can't go any further up
        else result = push_function_for_instance(L, [self class], selector);
    }
    
    END_STACK_MODIFY(L, 1);
    
    return result;
}

void push_userdata_for_instance(lua_State *L, id object) {
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

// Expects the objects userdata to be on the top of the stack
OBJLUA_METHOD(id)
OBJLUA_METHOD(int)
OBJLUA_METHOD(long)
OBJLUA_METHOD(float)
OBJLUA_METHOD(BOOL)