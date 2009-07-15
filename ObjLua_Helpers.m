//
//  ObjLua_Helpers.m
//  Lua
//
//  Created by ProbablyInteractive on 5/18/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "ObjLua_Helpers.h"
#import "ObjLua_Instance.h"
#import "ObjLua_Struct.h"
#import "lauxlib.h"

void objlua_print_stack(lua_State *L) {
    int i;
    int top = lua_gettop(L);
    
    for (i = 1; i <= top; i++) {        
        printf("%d: ", i);
        objlua_print_stack_at(L, i);
        printf("\n");
    }
    
    printf("\n");
}

void objlua_print_stack_at(lua_State *L, int i) {
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
        objlua_print_stack_at(L, -2);
        printf(" : ");
        objlua_print_stack_at(L, -1);
        printf("\n");

        lua_pop(L, 1); // remove 'value'; keeps 'key' for next iteration
    }
}

int objlua_from_objc(lua_State *L, const char *typeDescription, void *buffer) {
    BEGIN_STACK_MODIFY(L)
    
    int size = objlua_size_of_type_description(typeDescription);
    
    switch (typeDescription[0]) {
        case OBJLUA_TYPE_VOID:
            lua_pushnil(L);
            break;
            
        case OBJLUA_TYPE_CHAR:
            lua_pushinteger(L, *(char *)buffer);
            break;
            
        case OBJLUA_TYPE_SHORT:
            lua_pushinteger(L, *(short *)buffer);            
            break;
            
        case OBJLUA_TYPE_INT:
            lua_pushnumber(L, *(int *)buffer);
            break;

        case OBJLUA_TYPE_UNSIGNED_CHAR:
            lua_pushnumber(L, *(unsigned char *)buffer);
            break;

        case OBJLUA_TYPE_UNSIGNED_INT:
            lua_pushnumber(L, *(unsigned int *)buffer);
            break;

        case OBJLUA_TYPE_UNSIGNED_SHORT:
            lua_pushinteger(L, *(short *)buffer);
            break;
            
        case OBJLUA_TYPE_LONG:
            lua_pushnumber(L, *(long *)buffer);
            break;

        case OBJLUA_TYPE_LONG_LONG:
            lua_pushnumber(L, *(long long *)buffer);
            break;

        case OBJLUA_TYPE_UNSIGNED_LONG:
            lua_pushnumber(L, *(unsigned long *)buffer);
            break;

        case OBJLUA_TYPE_UNSIGNED_LONG_LONG:
            lua_pushnumber(L, *(unsigned long long *)buffer);
            break;

        case OBJLUA_TYPE_FLOAT:
            lua_pushnumber(L, *(float *)buffer);
            break;

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
            objlua_from_struct(L, typeDescription, buffer, size);
            break;
        }
            
        case OBJLUA_TYPE_SELECTOR:
            lua_pushstring(L, sel_getName(*(SEL *)buffer));
            break;            
            
        default:
            luaL_error(L, "Unable to convert Obj-C type with type description '%s'", typeDescription);
            break;
    }
    
    END_STACK_MODIFY(L, 1);
    
    return size;
}

void objlua_from_struct(lua_State *L, const char *typeDescription, void *buffer, int size) {
    objlua_struct_create(L, typeDescription, buffer, size);
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

#define OBJLUA_TO_INTEGER(_type_) *outsize = sizeof(_type_); value = calloc(sizeof(_type_), 1); *((_type_ *)value) = (_type_)lua_tointeger(L, stackIndex);
#define OBJLUA_TO_NUMBER(_type_) *outsize = sizeof(_type_); value = calloc(sizeof(_type_), 1); *((_type_ *)value) = (_type_)lua_tonumber(L, stackIndex);
#define OBJLUA_TO_BOOL_OR_CHAR(_type_) *outsize = sizeof(_type_); value = calloc(sizeof(_type_), 1); *((_type_ *)value) = (_type_)(lua_isboolean(L, stackIndex) ? lua_toboolean(L, stackIndex) : lua_tointeger(L, stackIndex));

void *objlua_to_objc(lua_State *L, const char *typeDescription, int stackIndex, int *outsize) {
    void *value = nil;

    if (outsize == nil) outsize = alloca(sizeof(int)); // if no outsize address set, treat it as a junk var
    
    switch (typeDescription[0]) {
        case OBJLUA_TYPE_C99_BOOL:
            OBJLUA_TO_BOOL_OR_CHAR(BOOL)
            break;            
            
        case OBJLUA_TYPE_CHAR:
            OBJLUA_TO_BOOL_OR_CHAR(char)
            break;
            
        case OBJLUA_TYPE_INT:
            OBJLUA_TO_INTEGER(int)
            break;            
            
        case OBJLUA_TYPE_SHORT:
            OBJLUA_TO_INTEGER(short)
            break;            
            
        case OBJLUA_TYPE_UNSIGNED_CHAR:
            OBJLUA_TO_INTEGER(unsigned char)
            break;            
            
        case OBJLUA_TYPE_UNSIGNED_INT:
            OBJLUA_TO_INTEGER(unsigned int)
            break;            
            
        case OBJLUA_TYPE_UNSIGNED_SHORT:
            OBJLUA_TO_INTEGER(unsigned short)
            break;
            
        case OBJLUA_TYPE_LONG:
            OBJLUA_TO_NUMBER(long)
            break;
            
        case OBJLUA_TYPE_LONG_LONG:
            OBJLUA_TO_NUMBER(long long)
            break;
            
        case OBJLUA_TYPE_UNSIGNED_LONG:
            OBJLUA_TO_NUMBER(unsigned long)
            break;
            
        case OBJLUA_TYPE_UNSIGNED_LONG_LONG:
            OBJLUA_TO_NUMBER(unsigned long long);
            break;            
            
        case OBJLUA_TYPE_FLOAT:
            OBJLUA_TO_NUMBER(float);
            break;
            
        case OBJLUA_TYPE_DOUBLE:
            OBJLUA_TO_NUMBER(double);
            break;
            
        case OBJLUA_TYPE_SELECTOR:
            *outsize = sizeof(SEL);
            value = calloc(sizeof(SEL), 1);
            *((SEL *)value) = sel_getUid(lua_tostring(L, stackIndex));
            break;            
            
        case OBJLUA_TYPE_STRING: {
            const char *string = lua_tostring(L, stackIndex);
            int length = strlen(string) + 1;
            *outsize = length;
            
            value = calloc(sizeof(char *), length);
            strcpy(value, string);
            break;
        }

        case OBJLUA_TYPE_ID: {
            *outsize = sizeof(id);

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
                ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, stackIndex, OBJLUA_INSTANCE_METATABLE_NAME);
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
            if (lua_isuserdata(L, stackIndex)) {
                ObjLua_Struct *objLuaStruct = (ObjLua_Struct *)luaL_checkudata(L, stackIndex, OBJLUA_STRUCT_METATABLE_NAME);
                objlua_struct_refresh(L, stackIndex); // If the struct has "magic" indexes, reload the struct data to match those
                
                value = objLuaStruct->data;
            }
            else {
                void *data = (void *)lua_tostring(L, stackIndex);            
                size_t length = lua_objlen(L, stackIndex);
                *outsize = length;
            
                value = malloc(length);
                memcpy(value, data, length);
            }
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

// I could get rid of this
const char *objlua_remove_protocol_encodings(const char *type_descriptions) {
    switch (type_descriptions[0]) {
        case OBJLUA_PROTOCOL_TYPE_INOUT:
        case OBJLUA_PROTOCOL_TYPE_OUT:
        case OBJLUA_PROTOCOL_TYPE_BYCOPY:
        case OBJLUA_PROTOCOL_TYPE_BYREF:
        case OBJLUA_PROTOCOL_TYPE_ONEWAY:
            return &type_descriptions[1];
            break;
        default:
            return type_descriptions;
            break;
    }
}

int objlua_size_of_type_description(const char *full_type_description) {
    int index = 0;
    int size = 0;
    
    size_t length = strlen(full_type_description) + 1;
    char *type_description = alloca(length);
    bzero(type_description, length);
    objlua_simplify_type_description(full_type_description, type_description);
    
    while(type_description[index]) {
        switch (type_description[index]) {
            case OBJLUA_TYPE_POINTER:
                size += sizeof(void *);
                
            case OBJLUA_TYPE_CHAR:
                size += sizeof(char);
                break;
                
            case OBJLUA_TYPE_INT:
                size += sizeof(int);
                break;
                
            case OBJLUA_TYPE_ARRAY:
                //OBJLUA_TYPE_ARRAY_END:
                assert(false); // Not implemented yet
                break;
            
            case OBJLUA_TYPE_SHORT:
                size += sizeof(short);
                break;
                
            case OBJLUA_TYPE_UNSIGNED_CHAR:
                size += sizeof(unsigned char);
                break;
                
            case OBJLUA_TYPE_UNSIGNED_INT:
                size += sizeof(unsigned int);
                break;
                
            case OBJLUA_TYPE_UNSIGNED_SHORT:
                size += sizeof(unsigned short);
                break;
                
            case OBJLUA_TYPE_LONG:
                size += sizeof(long);
                break;
                
            case OBJLUA_TYPE_LONG_LONG:
                size += sizeof(long long);
                break;
                
            case OBJLUA_TYPE_UNSIGNED_LONG:
                size += sizeof(unsigned long);
                break;
                
            case OBJLUA_TYPE_UNSIGNED_LONG_LONG:
                size += sizeof(unsigned long long);
                break;
                
            case OBJLUA_TYPE_FLOAT:
                size += sizeof(float);
                break;
                
            case OBJLUA_TYPE_DOUBLE:
                size += sizeof(double);
                break;
                
            case OBJLUA_TYPE_C99_BOOL:
                size += sizeof(_Bool);
                break;
                
            case OBJLUA_TYPE_STRING:
                size += sizeof(char *);
                break;
                
            case OBJLUA_TYPE_VOID:
                size += sizeof(void);
                break;
                
            case OBJLUA_TYPE_BITFIELD:
                assert(false); // I was to lazy to implement bitfields
                break;
                
            case OBJLUA_TYPE_ID:
                size += sizeof(id);
                break;
                
            case OBJLUA_TYPE_CLASS:
                size += sizeof(Class);
                break;
                
            case OBJLUA_TYPE_SELECTOR:
                size += sizeof(SEL);
                break;
                
            case OBJLUA_TYPE_STRUCT:
            case OBJLUA_TYPE_STRUCT_END:
            case OBJLUA_TYPE_UNION:
            case OBJLUA_TYPE_UNION_END:
            case OBJLUA_TYPE_UNKNOWN:                
            case OBJLUA_PROTOCOL_TYPE_CONST:                
            case OBJLUA_PROTOCOL_TYPE_IN:                
            case OBJLUA_PROTOCOL_TYPE_INOUT:
            case OBJLUA_PROTOCOL_TYPE_OUT:
            case OBJLUA_PROTOCOL_TYPE_BYCOPY:
            case OBJLUA_PROTOCOL_TYPE_BYREF:
            case OBJLUA_PROTOCOL_TYPE_ONEWAY:                    
                // Weeeee!
                break;
            default:
                assert(false); // "UNKNOWN TYPE ENCODING"
                break;
        }
        
        index++;
    }
    
    return size;
}

int objlua_simplify_type_description(const char *in, char *out) {
    int out_index = 0;
    int in_index = 0;
    
    while(in[in_index]) {
        switch (in[in_index]) {
            case OBJLUA_TYPE_STRUCT:
            case OBJLUA_TYPE_UNION:                
                for (; in[in_index] != '='; in_index++); // Eat the name!
                in_index++; // Eat the = sign 
                break;
                
            case OBJLUA_TYPE_ARRAY:                
                do {
                    out[out_index++] = in[in_index++];
                } while(in[in_index] != OBJLUA_TYPE_ARRAY_END);
                break;
                
            case OBJLUA_TYPE_POINTER: {
                //get rid of enternal stucture parts
                out[out_index++] = in[in_index++]; 
                for (; in[in_index] == '^'; in_index++); // Eat all the pointers
                
                switch (in[in_index]) {
                    case OBJLUA_TYPE_UNION:
                    case OBJLUA_TYPE_STRUCT: {
                        in_index++;
                        int openCurlies = 1;
                        
                        for (; openCurlies > 1 || (in[in_index] != OBJLUA_TYPE_UNION_END && in[in_index] != OBJLUA_TYPE_STRUCT_END); in_index++) {
                            if (in[in_index] == OBJLUA_TYPE_UNION || in[in_index] == OBJLUA_TYPE_STRUCT) openCurlies++;
                            else if (in[in_index] == OBJLUA_TYPE_UNION_END || in[in_index] == OBJLUA_TYPE_STRUCT_END) openCurlies--;
                        }
                        break;
                    }
                }
            }
                
            case OBJLUA_TYPE_STRUCT_END:
            case OBJLUA_TYPE_UNION_END:
                in_index++;
                break;
                
            default:
                out[out_index++] = in[in_index++];
                break;
        }
    }
    
    return out_index;
}