//
//  oink_helpers.m
//  Lua
//
//  Created by ProbablyInteractive on 5/18/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "oink_helpers.h"
#import "oink_instance.h"
#import "oink_struct.h"
#import "lauxlib.h"

void oink_printStack(lua_State *L) {
    int i;
    int top = lua_gettop(L);
    
    for (i = 1; i <= top; i++) {        
        printf("%d: ", i);
        oink_printStackAt(L, i);
        printf("\n");
    }
    
    printf("\n");
}

void oink_printStackAt(lua_State *L, int i) {
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

void oink_printTable(lua_State *L, int t) {
    // table is in the stack at index 't'
    
    lua_pushnil(L);  // first key
    if (t < 0) t--; // if t is negative, we need to updated it
    
    while (lua_next(L, t) != 0) {
        oink_printStackAt(L, -2);
        printf(" : ");
        oink_printStackAt(L, -1);
        printf("\n");

        lua_pop(L, 1); // remove 'value'; keeps 'key' for next iteration
    }
}

int oink_fromObjc(lua_State *L, const char *typeDescription, void *buffer) {
    BEGIN_STACK_MODIFY(L)
    
    int size = oink_sizeOfTypeDescription(typeDescription);
    
    switch (typeDescription[0]) {
        case OINK_TYPE_VOID:
            lua_pushnil(L);
            break;
            
        case OINK_TYPE_CHAR: {
            char c = *(char *)buffer;
            if (c <= 1) lua_pushboolean(L, c); // If it's 1 or 0, then treat it like a bool
            else lua_pushinteger(L, c);
            break;
        }
            
        case OINK_TYPE_SHORT:
            lua_pushinteger(L, *(short *)buffer);            
            break;
            
        case OINK_TYPE_INT:
            lua_pushnumber(L, *(int *)buffer);
            break;

        case OINK_TYPE_UNSIGNED_CHAR:
            lua_pushnumber(L, *(unsigned char *)buffer);
            break;

        case OINK_TYPE_UNSIGNED_INT:
            lua_pushnumber(L, *(unsigned int *)buffer);
            break;

        case OINK_TYPE_UNSIGNED_SHORT:
            lua_pushinteger(L, *(short *)buffer);
            break;
            
        case OINK_TYPE_LONG:
            lua_pushnumber(L, *(long *)buffer);
            break;

        case OINK_TYPE_LONG_LONG:
            lua_pushnumber(L, *(long long *)buffer);
            break;

        case OINK_TYPE_UNSIGNED_LONG:
            lua_pushnumber(L, *(unsigned long *)buffer);
            break;

        case OINK_TYPE_UNSIGNED_LONG_LONG:
            lua_pushnumber(L, *(unsigned long long *)buffer);
            break;

        case OINK_TYPE_FLOAT:
            lua_pushnumber(L, *(float *)buffer);
            break;

        case OINK_TYPE_DOUBLE:
            lua_pushnumber(L, *(double *)buffer);
            break;
            
        case OINK_TYPE_C99_BOOL:
            lua_pushboolean(L, *(BOOL *)buffer);
            break;
            
        case OINK_TYPE_STRING:
            lua_pushstring(L, *(char **)buffer);
            break;
            
        case OINK_TYPE_ID: {
            id instance = *(id *)buffer;
            oink_instance_create(L, instance, NO);
            break;
        }
            
        case OINK_TYPE_STRUCT: {
            oink_fromStruct(L, typeDescription, buffer);
            break;
        }
            
        case OINK_TYPE_SELECTOR:
            lua_pushstring(L, sel_getName(*(SEL *)buffer));
            break;            

        case OINK_TYPE_CLASS: {
            id instance = *(id *)buffer;
            oink_instance_create(L, instance, YES);
            break;                        
        }
            
        default:
            luaL_error(L, "Unable to convert Obj-C type with type description '%s'", typeDescription);
            break;
    }
    
    END_STACK_MODIFY(L, 1)
    
    return size;
}

void oink_fromStruct(lua_State *L, const char *typeDescription, void *buffer) {
    oink_struct_create(L, typeDescription, buffer);
}

void oink_fromInstance(lua_State *L, id instance) {
    BEGIN_STACK_MODIFY(L)
    
    if (instance) {
        if ([instance isKindOfClass:[NSString class]]) {    
            lua_pushstring(L, [(NSString *)instance UTF8String]);
        }
        else if ([instance isKindOfClass:[NSNumber class]]) {
            lua_pushnumber(L, [instance doubleValue]);
        }
        else {
            oink_instance_create(L, instance, NO);
        }
    }
    else {
        lua_pushnil(L);
    }
    
    END_STACK_MODIFY(L, 1)
}

#define OINK_TO_INTEGER(_type_) *outsize = sizeof(_type_); value = calloc(sizeof(_type_), 1); *((_type_ *)value) = (_type_)lua_tointeger(L, stackIndex);
#define OINK_TO_NUMBER(_type_) *outsize = sizeof(_type_); value = calloc(sizeof(_type_), 1); *((_type_ *)value) = (_type_)lua_tonumber(L, stackIndex);
#define OINK_TO_BOOL_OR_CHAR(_type_) *outsize = sizeof(_type_); value = calloc(sizeof(_type_), 1); *((_type_ *)value) = (_type_)(lua_isboolean(L, stackIndex) ? lua_toboolean(L, stackIndex) : lua_tointeger(L, stackIndex));

// MAKE SURE YOU RELEASE THIS!
void *oink_copyToObjc(lua_State *L, const char *typeDescription, int stackIndex, int *outsize) {
    void *value = nil;

    if (outsize == nil) outsize = alloca(sizeof(int)); // if no outsize address set, treat it as a junk var
    
    switch (typeDescription[0]) {
        case OINK_TYPE_C99_BOOL:
            OINK_TO_BOOL_OR_CHAR(BOOL)
            break;            
            
        case OINK_TYPE_CHAR:
            OINK_TO_BOOL_OR_CHAR(char)
            break;
            
        case OINK_TYPE_INT:
            OINK_TO_INTEGER(int)
            break;            
            
        case OINK_TYPE_SHORT:
            OINK_TO_INTEGER(short)
            break;            
            
        case OINK_TYPE_UNSIGNED_CHAR:
            OINK_TO_INTEGER(unsigned char)
            break;            
            
        case OINK_TYPE_UNSIGNED_INT:
            OINK_TO_INTEGER(unsigned int)
            break;            
            
        case OINK_TYPE_UNSIGNED_SHORT:
            OINK_TO_INTEGER(unsigned short)
            break;
            
        case OINK_TYPE_LONG:
            OINK_TO_NUMBER(long)
            break;
            
        case OINK_TYPE_LONG_LONG:
            OINK_TO_NUMBER(long long)
            break;
            
        case OINK_TYPE_UNSIGNED_LONG:
            OINK_TO_NUMBER(unsigned long)
            break;
            
        case OINK_TYPE_UNSIGNED_LONG_LONG:
            OINK_TO_NUMBER(unsigned long long);
            break;            
            
        case OINK_TYPE_FLOAT:
            OINK_TO_NUMBER(float);
            break;
            
        case OINK_TYPE_DOUBLE:
            OINK_TO_NUMBER(double);
            break;
            
        case OINK_TYPE_SELECTOR:
            *outsize = sizeof(SEL);
            value = calloc(sizeof(SEL), 1);
            *((SEL *)value) = sel_getUid(lua_tostring(L, stackIndex));
            break;            

        case OINK_TYPE_CLASS:
            *outsize = sizeof(Class);
            value = calloc(sizeof(Class), 1);
            if (lua_isuserdata(L, stackIndex)) {
                oink_instance_userdata *instanceUserdata = (oink_instance_userdata *)luaL_checkudata(L, stackIndex, OINK_INSTANCE_METATABLE_NAME);
                *(id *)value = instanceUserdata->instance;   
            }
            else {
                *((Class *)value) = objc_getClass(lua_tostring(L, stackIndex));
            }
            break;             
            
        case OINK_TYPE_STRING: {
            const char *string = lua_tostring(L, stackIndex);
            int length = strlen(string) + 1;
            *outsize = length;
            
            value = calloc(sizeof(char *), length);
            strcpy(value, string);
            break;
        }

        case OINK_TYPE_ID: {
            *outsize = sizeof(id);

            value = calloc(sizeof(id), 1);            
            // add number, string
            
            id instance;

            switch (lua_type(L, stackIndex)) {
                case LUA_TNIL:
                    instance = nil;
                    break;
                    
                case LUA_TBOOLEAN:
                case LUA_TNUMBER:
                    instance = [NSNumber numberWithDouble:lua_tonumber(L, stackIndex)];                    
                    break;
                    
                case LUA_TSTRING:
                    instance = [NSString stringWithCString:lua_tostring(L, stackIndex)];                    
                    break;
                    
                case LUA_TUSERDATA: {
                    oink_instance_userdata *instanceUserdata = (oink_instance_userdata *)luaL_checkudata(L, stackIndex, OINK_INSTANCE_METATABLE_NAME);
                    instance = instanceUserdata->instance;
                    break;                                  
                }
                default:
                    luaL_error(L, "Can't convert %s to obj-c.", luaL_typename(L, stackIndex));
                    break;
            }
            
            if (instance) {
                *(id *)value = instance;
            }
            
            break;
        }        
            
        case OINK_TYPE_STRUCT: {
            if (lua_isuserdata(L, stackIndex)) {
                oink_struct_userdata *structUserdata = (oink_struct_userdata *)luaL_checkudata(L, stackIndex, OINK_STRUCT_METATABLE_NAME);
                oink_struct_refresh(L, stackIndex); // If the struct has "magic" indexes, reload the struct data to match those
                
                value = malloc(structUserdata->size);
                memcpy(value, structUserdata->data, structUserdata->size);
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

oink_selectors oink_selectorsForName(const char *methodName) {
    oink_selectors posibleSelectors;
    int strlength = strlen(methodName) + 2; // Add 2. One for trailing : and one for \0
    char *objcMethodName = calloc(strlength, 1); 
    
    strcpy(objcMethodName, methodName);
    for(int i = 0; objcMethodName[i]; i++) if (objcMethodName[i] == '_') objcMethodName[i] = ':';
    
    posibleSelectors.selectors[0] = sel_getUid(objcMethodName);
    objcMethodName[strlength - 2] = ':';
    posibleSelectors.selectors[1] = sel_getUid(objcMethodName);
    free(objcMethodName);
    
    return posibleSelectors;
}
  SEL oink_selectorForInstance(oink_instance_userdata *instanceUserdata, const char *methodName) {
    SEL *posibleSelectors = &oink_selectorsForName(methodName).selectors[0];
    
    if (instanceUserdata->isClass) {
        if ([instanceUserdata->instance instancesRespondToSelector:posibleSelectors[0]]) return posibleSelectors[0];
        if ([instanceUserdata->instance instancesRespondToSelector:posibleSelectors[1]]) return posibleSelectors[1];    
    }
    else {
        if ([instanceUserdata->instance respondsToSelector:posibleSelectors[0]]) return posibleSelectors[0];
        if ([instanceUserdata->instance respondsToSelector:posibleSelectors[1]]) return posibleSelectors[1];    
    }
    
    return nil;
}

void oink_pushMethodNameFromSelector(lua_State *L, SEL selector) {
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
    
    END_STACK_MODIFY(L, 1)
}

// I could get rid of this
const char *oink_removeProtocolEncodings(const char *type_descriptions) {
    switch (type_descriptions[0]) {
        case OINK_PROTOCOL_TYPE_INOUT:
        case OINK_PROTOCOL_TYPE_OUT:
        case OINK_PROTOCOL_TYPE_BYCOPY:
        case OINK_PROTOCOL_TYPE_BYREF:
        case OINK_PROTOCOL_TYPE_ONEWAY:
            return &type_descriptions[1];
            break;
        default:
            return type_descriptions;
            break;
    }
}

int oink_sizeOfTypeDescription(const char *full_type_description) {
    int index = 0;
    int size = 0;
    
    size_t length = strlen(full_type_description) + 1;
    char *type_description = alloca(length);
    bzero(type_description, length);
    oink_simplifyTypeDescription(full_type_description, type_description);
    
    while(type_description[index]) {
        switch (type_description[index]) {
            case OINK_TYPE_POINTER:
                size += sizeof(void *);
                
            case OINK_TYPE_CHAR:
                size += sizeof(char);
                break;
                
            case OINK_TYPE_INT:
                size += sizeof(int);
                break;
                
            case OINK_TYPE_ARRAY:
                //OINK_TYPE_ARRAY_END:
                assert(false); // Not implemented yet
                break;
            
            case OINK_TYPE_SHORT:
                size += sizeof(short);
                break;
                
            case OINK_TYPE_UNSIGNED_CHAR:
                size += sizeof(unsigned char);
                break;
                
            case OINK_TYPE_UNSIGNED_INT:
                size += sizeof(unsigned int);
                break;
                
            case OINK_TYPE_UNSIGNED_SHORT:
                size += sizeof(unsigned short);
                break;
                
            case OINK_TYPE_LONG:
                size += sizeof(long);
                break;
                
            case OINK_TYPE_LONG_LONG:
                size += sizeof(long long);
                break;
                
            case OINK_TYPE_UNSIGNED_LONG:
                size += sizeof(unsigned long);
                break;
                
            case OINK_TYPE_UNSIGNED_LONG_LONG:
                size += sizeof(unsigned long long);
                break;
                
            case OINK_TYPE_FLOAT:
                size += sizeof(float);
                break;
                
            case OINK_TYPE_DOUBLE:
                size += sizeof(double);
                break;
                
            case OINK_TYPE_C99_BOOL:
                size += sizeof(_Bool);
                break;
                
            case OINK_TYPE_STRING:
                size += sizeof(char *);
                break;
                
            case OINK_TYPE_VOID:
                size += sizeof(void);
                break;
                
            case OINK_TYPE_BITFIELD:
                assert(false); // I was to lazy to implement bitfields
                break;
                
            case OINK_TYPE_ID:
                size += sizeof(id);
                break;
                
            case OINK_TYPE_CLASS:
                size += sizeof(Class);
                break;
                
            case OINK_TYPE_SELECTOR:
                size += sizeof(SEL);
                break;
                
            case OINK_TYPE_STRUCT:
            case OINK_TYPE_STRUCT_END:
            case OINK_TYPE_UNION:
            case OINK_TYPE_UNION_END:
            case OINK_TYPE_UNKNOWN:                
            case OINK_PROTOCOL_TYPE_CONST:                
            case OINK_PROTOCOL_TYPE_IN:                
            case OINK_PROTOCOL_TYPE_INOUT:
            case OINK_PROTOCOL_TYPE_OUT:
            case OINK_PROTOCOL_TYPE_BYCOPY:
            case OINK_PROTOCOL_TYPE_BYREF:
            case OINK_PROTOCOL_TYPE_ONEWAY:                    
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

int oink_simplifyTypeDescription(const char *in, char *out) {
    int out_index = 0;
    int in_index = 0;
    
    while(in[in_index]) {
        switch (in[in_index]) {
            case OINK_TYPE_STRUCT:
            case OINK_TYPE_UNION:                
                for (; in[in_index] != '='; in_index++); // Eat the name!
                in_index++; // Eat the = sign 
                break;
                
            case OINK_TYPE_ARRAY:            
                do {
                    out[out_index++] = in[in_index++];
                } while(in[in_index] != OINK_TYPE_ARRAY_END);
                break;
                
            case OINK_TYPE_POINTER: {
                //get rid of enternal stucture parts
                out[out_index++] = in[in_index++]; 
                for (; in[in_index] == '^'; in_index++); // Eat all the pointers
                
                switch (in[in_index]) {
                    case OINK_TYPE_UNION:
                    case OINK_TYPE_STRUCT: {
                        in_index++;
                        int openCurlies = 1;
                        
                        for (; openCurlies > 1 || (in[in_index] != OINK_TYPE_UNION_END && in[in_index] != OINK_TYPE_STRUCT_END); in_index++) {
                            if (in[in_index] == OINK_TYPE_UNION || in[in_index] == OINK_TYPE_STRUCT) openCurlies++;
                            else if (in[in_index] == OINK_TYPE_UNION_END || in[in_index] == OINK_TYPE_STRUCT_END) openCurlies--;
                        }
                        break;
                    }
                }
            }
                
            case OINK_TYPE_STRUCT_END:
            case OINK_TYPE_UNION_END:
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':                
                in_index++;
                break;
                
            default:
                out[out_index++] = in[in_index++];
                break;
        }
    }
    
    return out_index;
}