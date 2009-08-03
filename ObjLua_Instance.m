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
    {"__eq", __eq},
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
    
    END_STACK_MODIFY(L, 0)
    
    return 1;
}


// Creates userdata object for obj-c instance/class and pushes it onto the stack
ObjLua_Instance *objlua_instance_create(lua_State *L, id objcInstance, BOOL isClass) {
    BEGIN_STACK_MODIFY(L)
    
    // Does user data already exist?
    objlua_instance_push_userdata(L, objcInstance);
   
    if (lua_isnil(L, -1)) {
        lua_pop(L, 1); // pop nil stack
    }
    else {
        return lua_touserdata(L, -1);
    }
    
    size_t nbytes = sizeof(ObjLua_Instance);
    ObjLua_Instance *objlua_instance = (ObjLua_Instance *)lua_newuserdata(L, nbytes);
    objlua_instance->objcInstance = objcInstance;
    objlua_instance->isClass = isClass;
    objlua_instance->isSuper = NO;
 
    if (!isClass) {
        [objlua_instance->objcInstance retain];
    }
    
    // set the metatable
    luaL_getmetatable(L, OBJLUA_INSTANCE_METATABLE_NAME);
    lua_setmetatable(L, -2);

    // give it a nice clean environment
    // TODO: Is this step needed?
    lua_newtable(L); 
    lua_setfenv(L, -2);
    
    // look for weak table
    luaL_getmetatable(L, OBJLUA_INSTANCE_METATABLE_NAME);
    lua_getfield(L, -1, "__userdata");
    
    if (lua_isnil(L, -1)) { // Create new weak table, add it to metatable
        lua_settop(L, -2);
        lua_newtable(L);
        lua_pushstring(L, "v");
        lua_setfield(L, -2, "__mode");
        
        lua_pushstring(L, "__userdata");
        lua_pushvalue(L, -2);
        lua_rawset(L, -4);        
    }

    
    // register the userdata in the weak table in the metatable (so we can access it from obj-c)
    lua_pushlightuserdata(L, objlua_instance->objcInstance);
    lua_pushvalue(L, -4);
    lua_rawset(L, -3);
        
    lua_settop(L, -3); // Pop off table and metatable
    
    END_STACK_MODIFY(L, 1)
    
    return objlua_instance;
}

// Creates pseudo-super userdata object for obj-c instance and pushes it onto the stack
ObjLua_Instance *objlua_instance_createSuper(lua_State *L, ObjLua_Instance *objlua_instance) {
    BEGIN_STACK_MODIFY(L)
    
    size_t nbytes = sizeof(ObjLua_Instance);
    ObjLua_Instance *objlua_superInstance = (ObjLua_Instance *)lua_newuserdata(L, nbytes);
    objlua_superInstance->objcInstance = objlua_instance->objcInstance;
    objlua_superInstance->isClass = objlua_instance->isClass;
    objlua_superInstance->isSuper = YES;
    
    // set the metatable
    luaL_getmetatable(L, OBJLUA_INSTANCE_METATABLE_NAME);
    lua_setmetatable(L, -2);
        
    END_STACK_MODIFY(L, 1)
    
    return objlua_superInstance;
}

// First look in the object's userdata for the function, then look in the object's class's userdata
BOOL objlua_instance_push_function(lua_State *L, id self, SEL selector) {
    BEGIN_STACK_MODIFY(L)
    
    objlua_instance_push_userdata(L, self);
    if (lua_isnil(L, -1)) {
        END_STACK_MODIFY(L, 0)
        return NO; // userdata doesn't exist
    }
    
    lua_getfenv(L, -1);
    objlua_push_method_name_from_selector(L, selector);
    lua_rawget(L, -2);
    
    BOOL result = YES;
    
    if (!lua_isfunction(L, -1)) { // function not found in userdata
        if ([self class] == self) result = NO; // End of the line bub, can't go any further up
        else result = objlua_instance_push_function(L, [self class], selector);
    }
    
    END_STACK_MODIFY(L, 1)
    
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
    
    END_STACK_MODIFY(L, 1)
}

static int __index(lua_State *L) {
    ObjLua_Instance *objlua_instance = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);    
    
    if (lua_isstring(L, 2) && strcmp("super", lua_tostring(L, 2)) == 0) { // call to super!        
        objlua_instance_createSuper(L, objlua_instance);        
        return 1;
    }
    
    // Check instance userdata
    lua_getfenv(L, -2);
    lua_pushvalue(L, -2);
    lua_rawget(L, 3);

    // Check instance's class userdata
    if (lua_isnil(L, -1) && !objlua_instance->isClass && !objlua_instance->isSuper) {
        lua_pop(L, 1);
        
        objlua_instance_push_userdata(L, [objlua_instance->objcInstance class]);
        
        // If there is no userdata for this instance's class, then leave the nil on the stack and don't anything else
        if (!lua_isnil(L, -1)) {
            lua_getfenv(L, -1);
            lua_pushvalue(L, 2);
            lua_rawget(L, -2);
            lua_remove(L, -2); // Get rid of the userdata env
            lua_remove(L, -2); // Get rid of the userdata
        }        
    }
            
    if (objlua_instance->isSuper || lua_isnil(L, -1) ) { // Couldn't find that in the userdata environment table, assume it is defined in obj-c classes
        SEL selector = objlua_selector_for_instance(objlua_instance, lua_tostring(L, 2));

        if (selector) { // If the class has a method with this name, push as a closure            
            lua_pushstring(L, sel_getName(selector));
            lua_pushcclosure(L, objlua_instance->isSuper ? super_method_closure : method_closure, 1);
        }
    }
    else if (objlua_instance->isClass && strncmp(lua_tostring(L, 2), "init", 4) == 0) { // Is an init method create in lua?
        lua_pushcclosure(L, custom_init_method_closure, 1);
    }
    
    return 1;
}

static int __newindex(lua_State *L) {
    ObjLua_Instance *objlua_instance = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);
    
    // If this already exists in a protocol, or superclass make sure it will call the lua functions
    if (lua_type(L, 3) == LUA_TFUNCTION) {
        override_method(L, objlua_instance);
    }
    
    // Add value to the userdata's environment table
    lua_getfenv(L, 1);
    lua_insert(L, 2);
    lua_rawset(L, 2);        
    
    return 0;
}
    
static int __gc(lua_State *L) {
    ObjLua_Instance *objlua_instance = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);
    
    if (!objlua_instance->isClass) {
        luaL_getmetafield(L, -1, "__userdata");
        lua_pushlightuserdata(L, objlua_instance);
        lua_pushnil(L); // Remove this instance from the __userdata table.
        lua_rawset(L, -3);
        
        [objlua_instance->objcInstance release];
    }
    
    return 0;
}

static int __tostring(lua_State *L) {
    ObjLua_Instance *objlua_instance = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);
    lua_pushstring(L, [[NSString stringWithFormat:@"(%p => %p) %@", objlua_instance, objlua_instance->objcInstance, objlua_instance->objcInstance] UTF8String]);
    
    return 1;
}

static int __call(lua_State *L) {
    luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);
    void *rawObject = objlua_to_objc(L, @encode(id), 2, nil);
    objlua_instance_create(L, *(id *)rawObject, NO);
    free(rawObject);
    
    return 1;
}

static int __eq(lua_State *L) {
    ObjLua_Instance *o1 = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);
    ObjLua_Instance *o2 = (ObjLua_Instance *)luaL_checkudata(L, 2, OBJLUA_INSTANCE_METATABLE_NAME);
    
    lua_pushboolean(L, [o1->objcInstance isEqual:o2->objcInstance]);
    return 1;
}

int set_protocols(lua_State *L) {
    ObjLua_Instance *objlua_instance = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);
    
    if (!objlua_instance->isClass) {
        luaL_error(L, "ERROR: Can only set a protocol on a class for now");
        return 0;
    }
    
    for (int i = 2; i <= lua_gettop(L); i++) {
        const char *protocol_name = lua_tostring(L, i);
        Protocol *protocol = objc_getProtocol(protocol_name);
        if (!protocol) luaL_error(L, "Could not find protocol named '%s'", protocol_name);
        class_addProtocol(objlua_instance->objcInstance, protocol);
    }
    
    return 0;
}

static int method_closure(lua_State *L) {
    ObjLua_Instance *objlua_instance = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);    
    const char *selectorName = luaL_checkstring(L, lua_upvalueindex(1));
    SEL selector = sel_getUid(selectorName);
    BOOL autoAlloc = NO;
    
    if (objlua_instance->isClass && strncmp(selectorName, "init", 4) == 0) {
        // If init is called on a class, allocate it.
        // This is done to get around the placeholder stuff the foundation class uses
        objlua_instance = objlua_instance_create(L, [objlua_instance->objcInstance alloc], NO);
        autoAlloc = YES;
        
        // Also, replace the old userdata with the new one!
        lua_replace(L, 1);
    }
    
    NSMethodSignature *signature = [objlua_instance->objcInstance methodSignatureForSelector:selector];
    if (!signature) {
        const char *className = [NSStringFromClass([objlua_instance->objcInstance class]) UTF8String];
        luaL_error(L, "'%s' has no method selector '%s'", className, selectorName);
    }
    
    NSInvocation *invocation = nil;
    invocation = [NSInvocation invocationWithMethodSignature:signature];
        
    [invocation setTarget:objlua_instance->objcInstance];
    [invocation setSelector:selector];
    
    int objcArgumentCount = [signature numberOfArguments] - 2; // skip the hidden self and _cmd argument
    
    void **arguements = calloc(sizeof(void*), objcArgumentCount);
    for (int i = 0; i < objcArgumentCount; i++) {
        arguements[i] = objlua_to_objc(L, [signature getArgumentTypeAtIndex:i + 2], i + 2, nil);
        [invocation setArgument:arguements[i] atIndex:i + 2];
    }
    
    @try {
        [invocation invoke];
    }
    @catch (NSException *exception) {
        luaL_error(L, "Error invoking method '%s' on '%s' because %s", selector, class_getName([objlua_instance->objcInstance class]), [[exception description] UTF8String]);
    }
    
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

static int super_method_closure(lua_State *L) {
    ObjLua_Instance *objlua_instance = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);
    const char *selectorName = luaL_checkstring(L, lua_upvalueindex(1));    
    SEL selector = sel_getUid(selectorName);
    
    // Super Swizzle
    id instance = objlua_instance->objcInstance;

    Method selfMethod = class_getInstanceMethod([instance class], selector);
    Method superMethod = class_getInstanceMethod([instance superclass], selector);        
    
    if (superMethod && selfMethod != superMethod) { // Super's got what you're looking for
        IMP selfMethodImp = method_getImplementation(selfMethod);        
        IMP superMethodImp = method_getImplementation(superMethod);
        method_setImplementation(selfMethod, superMethodImp);
        
        method_closure(L);
        
        method_setImplementation(selfMethod, selfMethodImp); // Swap back to self's original method
    }
    else {
        method_closure(L);
    }
    
    
    return 1;
}

static int custom_init_method_closure(lua_State *L) {
    ObjLua_Instance *objlua_instance = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);
    
    if (objlua_instance->isClass) {
        objlua_instance = objlua_instance_create(L, [objlua_instance->objcInstance alloc], NO);
//        [objlua_instance->objcInstance release];
        lua_replace(L, 1); // replace the old userdata with the new one!
    }
    else {
        luaL_error(L, "I WAS TOLD THIS WAS A CUSTOM INIT METHOD. BUT YOU LIED TO ME");
    }
    
    lua_pushvalue(L, lua_upvalueindex(1)); // Grab the function!
    lua_insert(L, 1); // push it up top
    
    if (lua_pcall(L, lua_gettop(L) - 1, 1, 0)) {
        const char* error_string = lua_tostring(L, -1);
        luaL_error(L, "Custom init method on '%s' failed.\n%s", class_getName([objlua_instance->objcInstance class]), error_string);
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
                
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    int nargs = [signature numberOfArguments] - 1; // Don't send in the _cmd argument, only self
    int nresults = [signature methodReturnLength] ? 1 : 0;
        
    for (int i = 2; i < [signature numberOfArguments]; i++) { // start at 2 because to skip the automatic self and _cmd arugments
        const char *type = [signature getArgumentTypeAtIndex:i];
        int size = objlua_from_objc(L, type, args);
        args += size; // HACK! Since va_arg requires static type, I manually increment the args
    }

    if (lua_pcall(L, nargs, nresults, 0)) { // Userdata will allways be the first object sent to the function
        const char* error_string = lua_tostring(L, -1);
        luaL_error(L, "Error calling method '%s' on object for '%s'\n%s", selector, [[self description] UTF8String], error_string);
        goto error;
    }
    
    END_STACK_MODIFY(L, nresults)
    return nresults;
    
error:
    END_STACK_MODIFY(L, 0)
    return -1;
}

#define OBJLUA_METHOD_NAME(_type_) objlua_##_type_##_call

#define OBJLUA_METHOD(_type_) \
static _type_ OBJLUA_METHOD_NAME(_type_)(id self, SEL _cmd, ...) { \
va_list args; \
va_start(args, _cmd); \
va_list args_copy; \
va_copy(args_copy, args); \
/* Grab the static L... this is a hack */ \
lua_State *L = gL; \
BEGIN_STACK_MODIFY(L); \
int result = userdata_pcall(L, self, _cmd, args_copy); \
va_end(args_copy); \
va_end(args); \
if (result == -1) { \
    luaL_error(L, "Error calling '%s' on lua object '%s'", _cmd, [[self description] UTF8String]); \
} \
else if (result == 0) { \
    _type_ returnValue; \
    bzero(&returnValue, sizeof(_type_)); \
    END_STACK_MODIFY(L, 0) \
    return returnValue; \
} \
\
NSMethodSignature *signature = [self methodSignatureForSelector:_cmd]; \
_type_ *pReturnValue = (_type_ *)objlua_to_objc(L, [signature methodReturnType], -1, nil); \
_type_ returnValue = *pReturnValue; \
free(pReturnValue); \
END_STACK_MODIFY(L, 0) \
return returnValue; \
}

typedef struct _buffer_16 {char b[16];} buffer_16;

OBJLUA_METHOD(buffer_16)
OBJLUA_METHOD(id)
OBJLUA_METHOD(int)
OBJLUA_METHOD(long)
OBJLUA_METHOD(float)
OBJLUA_METHOD(BOOL) 

static BOOL override_method(lua_State *L, ObjLua_Instance *objlua_instance) {
    BEGIN_STACK_MODIFY(L);
    
    BOOL success = NO;
    const char *methodName = lua_tostring(L, 2);
    SEL selector = objlua_selector_for_instance(objlua_instance, methodName);
    Class class = [objlua_instance->objcInstance class];

    const char *typeDescription = nil;
    char *returnType = nil;
    
    Method method = class_getInstanceMethod(class, selector);
        
    if (method) { // Is method defined in the superclass?
        typeDescription = method_getTypeEncoding(method);        
        returnType = method_copyReturnType(method);
    }
    else { // Does this object implement a protocol with this method?
        uint count;
        Protocol **protocols = class_copyProtocolList(class, &count);
        
        SEL *posibleSelectors = &objlua_selectors_for_name(methodName).selectors[0];
        
        for (int i = 0; !returnType && i < count; i++) {
            Protocol *protocol = protocols[i];
            struct objc_method_description m_description;
            
            for (int j = 0; !returnType && j < 2; j++) {
                selector = posibleSelectors[j];
                
                m_description = protocol_getMethodDescription(protocol, selector, YES, YES);
                if (!m_description.name) m_description = protocol_getMethodDescription(protocol, selector, NO, YES); // Check if it is not a "required" method
                
                if (m_description.name) {
                    typeDescription = m_description.types;
                    returnType = method_copyReturnType((Method)&m_description);
                }
            }
        }
        
        free(protocols);
    }
    
    if (returnType) { // Matching method found! Create an Obj-C method on the 
//        const char *cleanReturnType = objlua_remove_protocol_encodings(returnType);

        IMP imp;
        switch (returnType[0]) {
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
                
            case OBJLUA_TYPE_STRUCT: {
                int size = objlua_size_of_type_description(returnType);
                switch (size) {
                    case 16:
                        imp = (IMP)OBJLUA_METHOD_NAME(buffer_16);
                        break;
                    default:
                        luaL_error(L, "Trying to override a method that has a struct return type of size '%d'. There is no implementation for this size yet.", size);
                        break;
                }
                break;
            }
                
            default:   
                luaL_error(L, "Can't handle method with return type %s", returnType);
                break;
        }
        
        success = class_addMethod(class, selector, imp, typeDescription);
        free(returnType);
    }
    else {
        NSLog(@"No method name '%s' found in superclass or protocols", methodName);
    }
    
    END_STACK_MODIFY(L, 1)
    return success;
}