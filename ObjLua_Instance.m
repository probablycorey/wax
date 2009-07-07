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
    {NULL, NULL}
};

static const struct luaL_Reg Methods[] = {
    {"set_protocols", set_protocols},
    {NULL, NULL}
};

int luaopen_objlua_instance(lua_State *L) {
    gL = L;
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
        lua_pushcclosure(L, objlua_method_closure, 2);
    }
    else {
        // Remove env table from stack
        lua_remove(L, -2);
    }
    
    return 1;
}

static int __newindex(lua_State *L) {
    ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, 1, OBJLUA_INSTANCE_METATABLE_NAME);
    
    if (lua_type(L, 3) == LUA_TFUNCTION) { 
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
                
                for (int i = 0; !type_encoding && i < 2; i++) {
                    selector = possible_selectors.selectors[i];

                    m_description = protocol_getMethodDescription(protocol, selector, YES, YES);
                    if (!&m_description) m_description = protocol_getMethodDescription(protocol, selector, NO, YES); // Check if it is not a "required" method
                    
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
            
            class_addMethod(class, selector, imp, type_encoding);

        }                                
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
    
    Protocol *protocol = objc_getProtocol(lua_tostring(L, 2));
    class_addProtocol(objLuaInstance->objcInstance, protocol);
    
    return 0;
}

static int objlua_method_closure(lua_State *L) {    
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
        arguements[i] = objlua_to_objc(L, [signature getArgumentTypeAtIndex:i + 2], i + 1);
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

// Expects the objects userdata to be on the top of the stack
OBJLUA_METHOD(id)
OBJLUA_METHOD(int)
OBJLUA_METHOD(long)
OBJLUA_METHOD(float)
OBJLUA_METHOD(BOOL)