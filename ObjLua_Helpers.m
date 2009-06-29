//
//  ObjLua_Helpers.m
//  Lua
//
//  Created by ProbablyInteractive on 5/18/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "ObjLua_Helpers.h"
#import "ObjLua_Instance.h"
#import "lauxlib.h"

#define BEGIN_STACK_MODIFY(L) \
    int __startStackIndex = lua_gettop((L));

#define END_STACK_MODIFY(L, i) \
    lua_settop((L), __startStackIndex + (i));

void objlua_stack_dump(lua_State *L) {
    int i;
    int top = lua_gettop(L);
    
    for (i = 1; i <= top; i++) {        
        printf("%d: ", i);
        objlua_print_stack_index(L, i);
        printf("\n");
    }
    
    printf("\n");
}

void objlua_print_stack_index(lua_State *L, int i) {
    int t = lua_type(L, i);
    printf("(%s) ", lua_typename(L, t));
    
    switch (t) {
        case LUA_TSTRING:
            printf("'%s'", lua_tostring(L, i));
            break;
        case LUA_TBOOLEAN:
            printf(lua_toboolean(L, i) ? "true" : "false");
            break;
        case LUA_TNUMBER:
            printf("'%g'", lua_tonumber(L, i));
            break;
        default:
            printf("%p", lua_topointer(L, i));
            break;
    }
}

void objlua_print_table(lua_State *L, int t) {
    // table is in the stack at index 't'
    
    lua_pushnil(L);  // first key
    if (t < 0) t--; // if t is negative, we need to updated it
    
    while (lua_next(L, t) != 0) {
        objlua_print_stack_index(L, -2);
        printf(" : ");
        objlua_print_stack_index(L, -1);
        printf("\n");

        lua_pop(L, 1); // remove 'value'; keeps 'key' for next iteration
    }
}

void objlua_from_objc(lua_State *L, const char *typeDescription, void *buffer, size_t size) {
    BEGIN_STACK_MODIFY(L)
    
    switch (typeDescription[0]) {
        case OBJLUA_TYPE_VOID:
            lua_pushnil(L);
            break;
            
        case OBJLUA_TYPE_CHAR:
        case OBJLUA_TYPE_INT:
        case OBJLUA_TYPE_SHORT:
        case OBJLUA_TYPE_UNSIGNED_CHAR:
        case OBJLUA_TYPE_UNSIGNED_INT:
        case OBJLUA_TYPE_UNSIGNED_SHORT:
            lua_pushinteger(L, *(int *)buffer);
            break;
            
        case OBJLUA_TYPE_LONG:
        case OBJLUA_TYPE_LONG_LONG:
        case OBJLUA_TYPE_UNSIGNED_LONG:
        case OBJLUA_TYPE_UNSIGNED_LONG_LONG:
        case OBJLUA_TYPE_FLOAT:
        case OBJLUA_TYPE_DOUBLE:
            lua_pushnumber(L, *(double *)buffer);
            break;
            
        case OBJLUA_TYPE_C99_BOOL:
            lua_pushboolean(L, *(BOOL *)buffer);
            break;
            
        case OBJLUA_TYPE_STRING:
            lua_pushstring(L, *(char **)buffer);
            break;
            
        case OBJLUA_TYPE_ID: {
            id instance = *(id *)buffer;

            objlua_from_objc_instance(L, instance);
            break;
        }
            
        case OBJLUA_TYPE_STRUCT: {
            if (size == 0) {
                // TODO: Can't get the size of an object from it's type signature yet
                luaL_error(L, "Can't get the size of an object from it's type signature yet, need to fix this");
            }
            
            objlua_from_struct(L, typeDescription, buffer, size);

            break;
        }
            
        default:
            luaL_error(L, "Unable to convert Obj-C type with type description '%s'", typeDescription);
            break;
    }
    
    END_STACK_MODIFY(L, 1)
}

void objlua_from_struct(lua_State *L, const char *typeDescription, void *buffer, size_t size) {
    if (strncmp("CGPoint", &typeDescription[1], 7) == 0) {
        CGPoint *point = (CGPoint *)buffer;
        lua_newtable(L);
        lua_pushnumber(L, point->x);
        lua_setfield(L, -2, "x");
        lua_pushnumber(L, point->y);        
        lua_setfield(L, -2, "y");
    }
    else {
        luaL_Buffer b;
        luaL_buffinit(L, &b);
        luaL_addlstring(&b, (const char *)buffer, size);
        luaL_pushresult(&b);
    }    
}

void objlua_from_objc_instance(lua_State *L, id instance) {
    BEGIN_STACK_MODIFY(L)
    
    if (instance) {
        if ([instance isKindOfClass:[NSString class]]) {
            lua_pushstring(L, [(NSString *)instance UTF8String]);
        }
        else if ([instance isKindOfClass:[NSNumber class]]) {
            lua_pushnumber(L, [instance doubleValue]);
        }
        else {
            objlua_instance_create(L, instance, NO);
        }
    }
    else {
        lua_pushnil(L);
    }
    
    END_STACK_MODIFY(L, 1)
}

void *objlua_to_objc(lua_State *L, const char *typeDescription, int stackIndex) {
    void *value = nil;
    
    switch (typeDescription[0]) {
        case OBJLUA_TYPE_CHAR:
        case OBJLUA_TYPE_INT:
        case OBJLUA_TYPE_SHORT:
        case OBJLUA_TYPE_UNSIGNED_CHAR:
        case OBJLUA_TYPE_UNSIGNED_INT:
        case OBJLUA_TYPE_UNSIGNED_SHORT:
            value = calloc(sizeof(LUA_INTEGER), 1);
            *((LUA_INTEGER *)value) = lua_tointeger(L, stackIndex);
            break;
            
        case OBJLUA_TYPE_LONG:
        case OBJLUA_TYPE_LONG_LONG:
        case OBJLUA_TYPE_UNSIGNED_LONG:
        case OBJLUA_TYPE_UNSIGNED_LONG_LONG:
        case OBJLUA_TYPE_FLOAT:
        case OBJLUA_TYPE_DOUBLE:
            value = calloc(sizeof(LUA_NUMBER), 1);
            *((LUA_NUMBER *)value) = lua_tonumber(L, stackIndex);
            break;
            
        case OBJLUA_TYPE_C99_BOOL:
            value = calloc(sizeof(int), 1);
            *((int *)value) = lua_tonumber(L, stackIndex);

            break;
            
        case OBJLUA_TYPE_STRING: {
            const char *string = lua_tostring(L, stackIndex);
            value = calloc(sizeof(char *), strlen(string) + 1);
            strcpy(value, string);


            break;
        }

        case OBJLUA_TYPE_ID: {
            value = calloc(sizeof(id), 1);
            
            // add number, dictionary and array
            
            id instance;
            if (lua_isstring(L, 1)) {
                instance = [NSString stringWithCString:lua_tostring(L, 1)];
            }
            else if(lua_isnil(L, 1)) {
                instance = nil;
            }
            else {
                ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)lua_topointer(L, stackIndex);                
                instance = objLuaInstance->objcInstance;
            }
            
            if (instance) {
                *(id *)value = instance;
            }
            break;
        }
        
            
        case OBJLUA_TYPE_STRUCT: {
            void *data = (void *)lua_tostring(L, stackIndex);
            
            size_t length = lua_objlen(L, stackIndex);
            value = malloc(length);
            memcpy(value, data, length);
            break;
        }
            
        default:
            luaL_error(L, "Unable to get type for Obj-C method argument with type description '%s'", typeDescription);
            break;
    }
    
    return value;
}

SEL objlua_selector_from_method_name(const char *methodName, int luaArgumentCount) {
    char *objcMethodName = calloc(strlen(methodName) + 2, 1);
    if (luaArgumentCount >= 1) {
        sprintf(objcMethodName, "%s:", methodName);
        
        for(int i = 0; i < strlen(objcMethodName); i++) {
            if (objcMethodName[i] == '_') objcMethodName[i] = ':';
        }
    }
    else {
        strcpy(objcMethodName, methodName);
    }
    
    SEL selector = sel_getUid(objcMethodName);
    
    free(objcMethodName);
    
    return selector;
}

void objlua_push_method_name_from_selector(lua_State *L, SEL selector) {
    BEGIN_STACK_MODIFY(L)
    const char *methodName = [NSStringFromSelector(selector) UTF8String];
    int length = strlen(methodName);
    
    luaL_Buffer b;
    luaL_buffinit(L, &b);    
    
    int i = 0;
    while(methodName[i]) {
        if (methodName[i] == ':') {
            if (i < length - 1) luaL_addchar(&b, '_');
        }
        else {
            luaL_addchar(&b, methodName[i]);
        }
        i++;
    }
    
    luaL_pushresult(&b);
    
    END_STACK_MODIFY(L, 1);
}

int objlua_userdata_pcall(lua_State *L, id self, SEL selector, ...) {
    BEGIN_STACK_MODIFY(L)
    int error = 0;
    
    objlua_push_userdata_for_object(L, self);
    lua_getfenv(L, -1);
    objlua_push_method_name_from_selector(L, selector);
    lua_rawget(L, -2);
    
    if (lua_isnil(L, -1)) { // method does not exist...
        error = -1;
        goto cleanup;
    }
    
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    int nargs = [signature numberOfArguments] - 1; // We won't send in the _cmd argument
    int nresults = [signature methodReturnLength] ? 1 : 0;
    
    va_list argp;
    va_start(argp, selector);
    
    // Push userdata as the first argument
    lua_pushvalue(L, -3);
    
    for (int i = 2; i < [signature numberOfArguments]; i++) { // i = 2 because we skip the automatic self and _cmd arugments
        void *arg = va_arg(argp, void *);
        objlua_from_objc(L, [signature getArgumentTypeAtIndex:i], arg, 0);
    }
    va_end(argp);
    
    if (lua_pcall(L, nargs, nresults, 0)) { // Userdata will allways be the first object sent to the function
        const char* error_string = lua_tostring(L, -1);
        NSLog(@"Pig Error: Problem calling Lua function '%@' on userdata (%s)", NSStringFromSelector(selector), error_string);
        error = -1;
        goto cleanup;
    }
    
cleanup:
    END_STACK_MODIFY(L, 0);
    return error;
}

void objlua_push_userdata_for_object(lua_State *L, id object) {
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