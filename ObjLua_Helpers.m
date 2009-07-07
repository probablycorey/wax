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
    while(lua_gettop((L)) > (__startStackIndex + i)) lua_remove(L, __startStackIndex + 1)

struct hacked_objc_class {
    struct hacked_objc_class *isa;
    struct hacked_objc_class *super_class;
};

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
            lua_pushinteger(L, *(char *)buffer);
        case OBJLUA_TYPE_SHORT:
            lua_pushinteger(L, *(short *)buffer);            

        case OBJLUA_TYPE_INT:
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
    
    END_STACK_MODIFY(L, 1);
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
    
    END_STACK_MODIFY(L, 1);
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
            value = calloc(sizeof(LUA_NUMBER), 1);
            *((long long*)value) = lua_tonumber(L, stackIndex);
            break;
            
        case OBJLUA_TYPE_FLOAT:
            value = calloc(sizeof(LUA_NUMBER), 1);
            *((float *)value) = lua_tonumber(L, stackIndex);
            break;
            
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
            
            // add number, string
            
            id instance;
            if (lua_isstring(L, stackIndex)) {
                instance = [NSString stringWithCString:lua_tostring(L, stackIndex)];
            }
            else if (lua_isnumber(L, stackIndex) || lua_isboolean(L, stackIndex)) {
                instance = [NSNumber numberWithDouble:lua_tonumber(L, stackIndex)];
            }
            else if (lua_isuserdata(L, stackIndex)) {
                ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)lua_topointer(L, stackIndex);                
                instance = objLuaInstance->objcInstance;
            }
            else if(lua_isnoneornil(L, stackIndex)) {
                instance = nil;
            }            
            else if (lua_istable(L, stackIndex)) {
                luaL_error(L, "Can't convert tables to obj-c.");
            }
            else if (lua_isfunction(L, stackIndex)) {
                luaL_error(L, "Can't convert function to obj-c.");
            }            
            else {
                luaL_error(L, "Can't convert %s to obj-c.", luaL_typename(L, stackIndex));
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

Objlua_selectors objlua_selector_from_method_name(const char *methodName) {
    int strlength = strlen(methodName) + 2; // Add 2. One for trailing : and one for \0
    char *objcMethodName = calloc(strlength, 1); 

    strcpy(objcMethodName, methodName);
    for(int i = 0; objcMethodName[i]; i++) if (objcMethodName[i] == '_') objcMethodName[i] = ':';
    
    Objlua_selectors posibleSelectors;
    posibleSelectors.selectors[0] = sel_getUid(objcMethodName);
    objcMethodName[strlength - 2] = ':';
    posibleSelectors.selectors[1] = sel_getUid(objcMethodName);
    
    free(objcMethodName);
    
    return posibleSelectors;
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

// Go up the object heirarchy looking for the lua method!
BOOL objlua_userdata_function(lua_State *L, id self, SEL selector) {
    BEGIN_STACK_MODIFY(L)
    
    objlua_push_userdata_for_object(L, self);
    if (lua_isnil(L, -1)) {
        END_STACK_MODIFY(L, 0);
        return NO; // userdata doesn't exist does not exist...
    }
    
    lua_getfenv(L, -1);
    objlua_push_method_name_from_selector(L, selector);
    lua_rawget(L, -2);

    BOOL result = YES;
    
    if (lua_isnil(L, -1)) { // method does not exist...
        result = objlua_userdata_function(L, [self class], selector);
    }
    
    END_STACK_MODIFY(L, 1);
    
    return result;
}

//static int objlua_super_closure(lua_State *L) {
//    ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, lua_upvalueindex(1), OBJLUA_INSTANCE_METATABLE_NAME);
//    const char *methodName = luaL_checkstring(L, lua_upvalueindex(2));    
//
//    SEL selector;
//    NSMethodSignature *signature = nil;
//    
//    Objlua_selectors possible_selectors = objlua_selector_from_method_name(methodName);        
//    for (int i = 0; !signature && i < 2; i++) {
//        selector = possible_selectors.selectors[i];
//        signature = [objLuaInstance->objcInstance methodSignatureForSelector:selector];
//    }
//        
//    int objcArgumentCount = [signature numberOfArguments] - 2; // skip the first two because self and _cmd are always the first two
//    
//    void *buffer = malloc([signature frameLength]);
//    int
//    for (int i = 0; i < objcArgumentCount; i++) {
//        buffer[i] = objlua_to_objc(L, [signature getArgumentTypeAtIndex:i + 2], i + 1);
//    }
//
//    struct objc_super s = { objLuaInstance->objcInstance, [objLuaInstance->objcInstance superclass] };
//    id returnValue = objc_msgSendSuper(&s, selector, buffer); // A hack! For now a buffer of the objects it expects works
//    objlua_from_objc_instance(L, returnValue);
//    
//    free(buffer);
//    
//    return 1;
//}


int objlua_userdata_pcall(lua_State *L, id self, SEL selector, va_list args) {
    BEGIN_STACK_MODIFY(L)
    
    // Find the method... could be in the object or in the class
    if (!objlua_userdata_function(L, self, selector)) goto error; // method does not exist...

    // add a secret "super" object to the function
    struct objc_object self_super = *(struct objc_object *)self;
    self_super.isa = [self superclass]; // The nerds call this "method swizzling"
    
    lua_getfenv(L, -1);
    objlua_instance_create(L, &self_super, NO);
    lua_setfield(L, -2, "super");
    lua_settop(L, -2); // Pop env table
    
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    int nargs = [signature numberOfArguments] - 1; // We won't send in the _cmd argument
    int nresults = [signature methodReturnLength] ? 1 : 0;
        
    // Push userdata as the first argument
    objlua_from_objc_instance(L, self);
    if (lua_isnil(L, -1)) goto error;    
    
    for (int i = 2; i < [signature numberOfArguments]; i++) { // start at 2 because to skip the automatic self and _cmd arugments
        const char *type = [signature getArgumentTypeAtIndex:i];
        id arg = va_arg(args, id);
        objlua_from_objc(L, type, &arg, 0);
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
    
    END_STACK_MODIFY(L, 1);
}

const char *objlua_remove_protocol_encodings(const char *type_encodings) {
    switch (type_encodings[0]) {
        case OBJLUA_PROTOCOL_TYPE_INOUT:
        case OBJLUA_PROTOCOL_TYPE_OUT:
        case OBJLUA_PROTOCOL_TYPE_BYCOPY:
        case OBJLUA_PROTOCOL_TYPE_BYREF:
        case OBJLUA_PROTOCOL_TYPE_ONEWAY:
            return &type_encodings[1];
            break;
        default:
            return type_encodings;
            break;
    }
}