//
//  wax_helpers.m
//  Lua
//
//  Created by ProbablyInteractive on 5/18/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "wax_helpers.h"
#import "wax_instance.h"
#import "wax_struct.h"
#import "lauxlib.h"

@interface WaxFunction : NSObject {}
@end

@implementation WaxFunction // Used to pass lua fuctions around
@end

void wax_printStack(lua_State *L) {
    int i;
    int top = lua_gettop(L);
    
    for (i = 1; i <= top; i++) {        
        printf("%d: ", i);
        wax_printStackAt(L, i);
        printf("\n");
    }
    
    printf("\n");
}

void wax_printStackAt(lua_State *L, int i) {
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

void wax_printTable(lua_State *L, int t) {
    // table is in the stack at index 't'
    
    if (t < 0) t = lua_gettop(L) + t + 1; // if t is negative, we need to normalize
	if (t <= 0 || t > lua_gettop(L)) {
		printf("%d is not within stack boundries.\n", t);
		return;
	}
	else if (!lua_istable(L, t)) {
		printf("Object at stack index %d is not a table.\n", t);
		return;
	}

	lua_pushnil(L);  // first key
    while (lua_next(L, t) != 0) {
        wax_printStackAt(L, -2);
        printf(" : ");
        wax_printStackAt(L, -1);
        printf("\n");

        lua_pop(L, 1); // remove 'value'; keeps 'key' for next iteration
    }
}

void wax_log(int flag, NSString *format, ...) {
    if (flag & LOG_FLAGS) {
        va_list args;
        va_start(args, format);
        NSString *output = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];
        printf("%s\n", [output UTF8String]);
        va_end(args);
    }
}

int wax_getStackTrace(lua_State *L) {
    lua_getfield(L, LUA_GLOBALSINDEX, "debug");
    if (!lua_istable(L, -1)) {
        lua_pop(L, 1);
        return 1;
    }
    
    lua_getfield(L, -1, "traceback");
    if (!lua_isfunction(L, -1)) {
        lua_pop(L, 2);
        return 1;
    }    
    lua_remove(L, -2); // Remove debug
    
    lua_call(L, 0, 1);    
    return 1;
}

int wax_fromObjc(lua_State *L, const char *typeDescription, void *buffer) {
    BEGIN_STACK_MODIFY(L)
    
    typeDescription = wax_removeProtocolEncodings(typeDescription);
    
    int size = wax_sizeOfTypeDescription(typeDescription);
    
    switch (typeDescription[0]) {
        case WAX_TYPE_VOID:
            lua_pushnil(L);
            break;

        case WAX_TYPE_POINTER:
            lua_pushlightuserdata(L, *(void **)buffer);
            break;                        
            
        case WAX_TYPE_CHAR: {
            char c = *(char *)buffer;
            if (c <= 1) lua_pushboolean(L, c); // If it's 1 or 0, then treat it like a bool
            else lua_pushinteger(L, c);
            break;
        }
            
        case WAX_TYPE_SHORT:
            lua_pushinteger(L, *(short *)buffer);            
            break;
            
        case WAX_TYPE_INT:
            lua_pushnumber(L, *(int *)buffer);
            break;

        case WAX_TYPE_UNSIGNED_CHAR:
            lua_pushnumber(L, *(unsigned char *)buffer);
            break;

        case WAX_TYPE_UNSIGNED_INT:
            lua_pushnumber(L, *(unsigned int *)buffer);
            break;

        case WAX_TYPE_UNSIGNED_SHORT:
            lua_pushinteger(L, *(short *)buffer);
            break;
            
        case WAX_TYPE_LONG:
            lua_pushnumber(L, *(long *)buffer);
            break;

        case WAX_TYPE_LONG_LONG:
            lua_pushnumber(L, *(long long *)buffer);
            break;

        case WAX_TYPE_UNSIGNED_LONG:
            lua_pushnumber(L, *(unsigned long *)buffer);
            break;

        case WAX_TYPE_UNSIGNED_LONG_LONG:
            lua_pushnumber(L, *(unsigned long long *)buffer);
            break;

        case WAX_TYPE_FLOAT:
            lua_pushnumber(L, *(float *)buffer);
            break;

        case WAX_TYPE_DOUBLE:
            lua_pushnumber(L, *(double *)buffer);
            break;
            
        case WAX_TYPE_C99_BOOL:
            lua_pushboolean(L, *(BOOL *)buffer);
            break;
            
        case WAX_TYPE_STRING:
            lua_pushstring(L, *(char **)buffer);
            break;
            
        case WAX_TYPE_ID: {
            id instance = *(id *)buffer;
            wax_fromInstance(L, instance);
            break;
        }
            
        case WAX_TYPE_STRUCT: {
            wax_fromStruct(L, typeDescription, buffer);
            break;
        }
            
        case WAX_TYPE_SELECTOR:
            lua_pushstring(L, sel_getName(*(SEL *)buffer));
            break;            

        case WAX_TYPE_CLASS: {
            id instance = *(id *)buffer;
            wax_instance_create(L, instance, YES);
            break;                        
        }
            
        default:
            luaL_error(L, "Unable to convert Obj-C type with type description '%s'", typeDescription);
            break;
    }
    
    END_STACK_MODIFY(L, 1)
    
    return size;
}

void wax_fromStruct(lua_State *L, const char *typeDescription, void *buffer) {
    wax_struct_create(L, typeDescription, buffer);
}

void wax_fromInstance(lua_State *L, id instance) {
    BEGIN_STACK_MODIFY(L)
    
    if (instance) {
        if ([instance isKindOfClass:[NSString class]]) {    
            lua_pushstring(L, [(NSString *)instance UTF8String]);
        }
        else if ([instance isKindOfClass:[NSNumber class]]) {
            lua_pushnumber(L, [instance doubleValue]);
        }
        else if ([instance isKindOfClass:[NSArray class]]) {
            lua_newtable(L);
            for (id obj in instance) {
                int i = lua_objlen(L, -1);
                wax_fromInstance(L, obj);
                lua_rawseti(L, -2, i + 1);
            }
        }
        else if ([instance isKindOfClass:[NSDictionary class]]) {
            lua_newtable(L);
            for (id key in instance) {
                wax_fromInstance(L, key);
                wax_fromInstance(L, [instance objectForKey:key]);
                lua_rawset(L, -3);
            }
        }                
        else if ([instance isKindOfClass:[NSValue class]]) {
            void *buffer = malloc(wax_sizeOfTypeDescription([instance objCType]));
            [instance getValue:buffer];
            wax_fromObjc(L, [instance objCType], buffer);
            free(buffer);
        }    
		else if ([instance isKindOfClass:[WaxFunction class]]) {
			wax_instance_pushUserdata(L, instance);
			if (lua_isnil(L, -1)) {
				luaL_error(L, "Could not get userdata associated with WaxFunction");
			}
			lua_getfield(L, -1, "function");
		}
        else {
            wax_instance_create(L, instance, NO);
        }
    }
    else {
        lua_pushnil(L);
    }
    
    END_STACK_MODIFY(L, 1)
}

#define WAX_TO_INTEGER(_type_) *outsize = sizeof(_type_); value = calloc(sizeof(_type_), 1); *((_type_ *)value) = (_type_)lua_tointeger(L, stackIndex);
#define WAX_TO_NUMBER(_type_) *outsize = sizeof(_type_); value = calloc(sizeof(_type_), 1); *((_type_ *)value) = (_type_)lua_tonumber(L, stackIndex);
#define WAX_TO_BOOL_OR_CHAR(_type_) *outsize = sizeof(_type_); value = calloc(sizeof(_type_), 1); *((_type_ *)value) = (_type_)(lua_isstring(L, stackIndex) ? lua_tostring(L, stackIndex)[0] : lua_toboolean(L, stackIndex));

// MAKE SURE YOU RELEASE THE RETURN VALUE!
void *wax_copyToObjc(lua_State *L, const char *typeDescription, int stackIndex, int *outsize) {
    void *value = nil;

    // Ignore method encodings
    switch (typeDescription[0]) {
        case WAX_PROTOCOL_TYPE_CONST:
        case WAX_PROTOCOL_TYPE_IN:
        case WAX_PROTOCOL_TYPE_INOUT:
        case WAX_PROTOCOL_TYPE_OUT:
        case WAX_PROTOCOL_TYPE_BYCOPY:
        case WAX_PROTOCOL_TYPE_BYREF:
        case  WAX_PROTOCOL_TYPE_ONEWAY:
            typeDescription = typeDescription + 1; // Skip first
            break;
    }

    
    if (outsize == nil) outsize = alloca(sizeof(int)); // if no outsize address set, treat it as a junk var
    
    switch (typeDescription[0]) {
        case WAX_TYPE_C99_BOOL:
            WAX_TO_BOOL_OR_CHAR(BOOL)
            break;            
            
        case WAX_TYPE_CHAR:
            WAX_TO_BOOL_OR_CHAR(char)
            break;
            
        case WAX_TYPE_INT:
            WAX_TO_INTEGER(int)
            break;            
            
        case WAX_TYPE_SHORT:
            WAX_TO_INTEGER(short)
            break;            
            
        case WAX_TYPE_UNSIGNED_CHAR:
            WAX_TO_INTEGER(unsigned char)
            break;            
            
        case WAX_TYPE_UNSIGNED_INT:
            WAX_TO_INTEGER(unsigned int)
            break;            
            
        case WAX_TYPE_UNSIGNED_SHORT:
            WAX_TO_INTEGER(unsigned short)
            break;
            
        case WAX_TYPE_LONG:
            WAX_TO_NUMBER(long)
            break;
            
        case WAX_TYPE_LONG_LONG:
            WAX_TO_NUMBER(long long)
            break;
            
        case WAX_TYPE_UNSIGNED_LONG:
            WAX_TO_NUMBER(unsigned long)
            break;
            
        case WAX_TYPE_UNSIGNED_LONG_LONG:
            WAX_TO_NUMBER(unsigned long long);
            break;            
            
        case WAX_TYPE_FLOAT:
            WAX_TO_NUMBER(float);
            break;
            
        case WAX_TYPE_DOUBLE:
            WAX_TO_NUMBER(double);
            break;
            
        case WAX_TYPE_SELECTOR:
            if (lua_isnil(L, stackIndex)) { // If no slector is passed it, just use an empty string
                lua_pushstring(L, "");
                lua_replace(L, stackIndex);
            }
            
            *outsize = sizeof(SEL);
            value = calloc(sizeof(SEL), 1);
            const char *selectorName = luaL_checkstring(L, stackIndex);
            *((SEL *)value) = sel_getUid(selectorName);                

            break;            

        case WAX_TYPE_CLASS:
            *outsize = sizeof(Class);
            value = calloc(sizeof(Class), 1);
            if (lua_isuserdata(L, stackIndex)) {
                wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, stackIndex, WAX_INSTANCE_METATABLE_NAME);
                *(id *)value = instanceUserdata->instance;   
            }
            else {
                *((Class *)value) = objc_getClass(lua_tostring(L, stackIndex));
            }
            break;             
            
        case WAX_TYPE_STRING: {
            const char *string = lua_tostring(L, stackIndex);
            int length = strlen(string) + 1;
            *outsize = length;
            
            value = calloc(sizeof(char *), length);
            strcpy(value, string);
            break;
        }

        case WAX_TYPE_POINTER:
            *outsize = sizeof(void *);
            
            value = calloc(sizeof(void *), 1);            
            void *pointer = nil;
            
            switch (typeDescription[1]) {
                case WAX_TYPE_VOID:
                case WAX_TYPE_ID: {
                    switch (lua_type(L, stackIndex)) {
                        case LUA_TNIL:
                        case LUA_TNONE:
                            break;
                            
                        case LUA_TUSERDATA: {
                            wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, stackIndex, WAX_INSTANCE_METATABLE_NAME);
							if (typeDescription[1] == WAX_TYPE_VOID) {
								pointer = instanceUserdata->instance;
							}
							else {
								pointer = &instanceUserdata->instance;
							}

                            break;                                  
                        }
                        default:
                            luaL_error(L, "Can't convert %s to wax_instance_userdata.", luaL_typename(L, stackIndex));
                            break;
                    }    
                    break;
                }
                default:
                    if (lua_islightuserdata(L, stackIndex)) {
                        pointer = lua_touserdata(L, stackIndex);
                    }
                    else {
                        free(value);
                        luaL_error(L, "Converstion from %s to Objective-c not implemented.", typeDescription);
                    }
            }
            
            if (pointer) {
                memcpy(value, &pointer, *outsize);
            }   
            
            break;
            
        case WAX_TYPE_ID: {
            *outsize = sizeof(id);

            value = calloc(sizeof(id), 1);            
            // add number, string
            
            id instance = nil;

            switch (lua_type(L, stackIndex)) {
                case LUA_TNIL:
                case LUA_TNONE:
                    instance = nil;
                    break;
                    
                case LUA_TBOOLEAN: {
                    BOOL value = lua_toboolean(L, stackIndex);
                    instance = [NSValue valueWithBytes:&value objCType:@encode(bool)];
                    break;
                }
                case LUA_TNUMBER:
                    instance = [NSNumber numberWithDouble:lua_tonumber(L, stackIndex)];                    
                    break;
                    
                case LUA_TSTRING: 
                    instance = [NSString stringWithUTF8String:lua_tostring(L, stackIndex)];  
                    break;

                case LUA_TTABLE: {
                    BOOL dictionary = NO;
                    
                    lua_pushvalue(L, stackIndex); // Push the table reference on the top
                    lua_pushnil(L);  /* first key */
                    while (!dictionary && lua_next(L, -2)) {
                        if (lua_type(L, -2) != LUA_TNUMBER) {
                            dictionary = YES;                        
                            lua_pop(L, 2); // pop key and value off the stack
                        }
                        else {
                            lua_pop(L, 1);
                        }
                    }
                                        
                    if (dictionary) {
                        instance = [NSMutableDictionary dictionary];
                        
                        lua_pushnil(L);  /* first key */
                        while (lua_next(L, -2)) {
                            id *key = wax_copyToObjc(L, "@", -2, nil);
                            id *object = wax_copyToObjc(L, "@", -1, nil);
                            [instance setObject:*object forKey:*key];
                            lua_pop(L, 1); // Pop off the value
                            free(key);
                            free(object);
                        }                        
                    }
                    else {
                        instance = [NSMutableArray array];
                        
                        lua_pushnil(L);  /* first key */
                        while (lua_next(L, -2)) {
                            int index = lua_tonumber(L, -2) - 1;
                            id *object = wax_copyToObjc(L, "@", -1, nil);
                            [instance insertObject:*object atIndex:index];
                            lua_pop(L, 1);
                            free(object);
                        }                                
                    }
                      
                    lua_pop(L, 1); // Pop the table reference off 
                    break;
                }
                                        
                case LUA_TUSERDATA: {
                    wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, stackIndex, WAX_INSTANCE_METATABLE_NAME);
                    instance = instanceUserdata->instance;
                    break;                                  
                }
                case LUA_TLIGHTUSERDATA: {
                    instance = lua_touserdata(L, -1);
                    break;
                }
				case LUA_TFUNCTION: {
				    instance = [[[WaxFunction alloc] init] autorelease];
				    wax_instance_create(L, instance, NO);
				    lua_pushvalue(L, -2);
				    lua_setfield(L, -2, "function"); // Stores function inside of this instance
					lua_pop(L, 1);
					
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
            
        case WAX_TYPE_STRUCT: {
            if (lua_isuserdata(L, stackIndex)) {
                wax_struct_userdata *structUserdata = (wax_struct_userdata *)luaL_checkudata(L, stackIndex, WAX_STRUCT_METATABLE_NAME);
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

// You can't tell if there are 0 or 1 arguments based on selector alone, so pass in an SEL[2] for possibleSelectors
void wax_selectorsForName(const char *methodName, SEL possibleSelectors[2]) {
    int strlength = strlen(methodName) + 2; // Add 2. One for trailing : and one for \0
    char *objcMethodName = calloc(strlength, 1); 
    
    int argCount = 0;
    strcpy(objcMethodName, methodName);
    for(int i = 0; objcMethodName[i]; i++) {
        if (objcMethodName[i] == '_') {
            argCount++;
            objcMethodName[i] = ':';
        }
    }
    
    objcMethodName[strlength - 2] = ':'; // Add final arg portion
    possibleSelectors[0] = sel_getUid(objcMethodName);
    
    if (argCount == 0) {
        objcMethodName[strlength - 2] = '\0';
        possibleSelectors[1] = sel_getUid(objcMethodName);        
    }
    else {
        possibleSelectors[1] = nil;
    }


    free(objcMethodName);
}

BOOL wax_selectorForInstance(wax_instance_userdata *instanceUserdata, SEL* foundSelectors, const char *methodName, BOOL forceInstanceCheck) {    
    SEL possibleSelectors[2];
    wax_selectorsForName(methodName, possibleSelectors);
    
    for (int i = 0; i < 2; i++) {
        SEL selector = possibleSelectors[i];
        if (!selector) continue; // There may be only one acceptable selector (i.e. methods with multiple keyword args)
        
        BOOL addSelector = NO;
        if (instanceUserdata->isClass && (forceInstanceCheck || wax_isInitMethod(methodName))) {
            if ([instanceUserdata->instance instanceMethodSignatureForSelector:selector]) addSelector = YES;
        }
        else {
            if ([instanceUserdata->instance methodSignatureForSelector:selector]) addSelector = YES;
        }    
        
        if (addSelector) {
            if (!foundSelectors[0]) foundSelectors[0] = selector;
            else foundSelectors[1] = selector;
        }
    }
    
    // True if it found any selectors
    return foundSelectors[0] || foundSelectors[1];
}

void wax_pushMethodNameFromSelector(lua_State *L, SEL selector) {
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

// Wax assumes anything that starts with init[A-Z0-9]? is an init method
BOOL wax_isInitMethod(const char *methodName) {
    if (strncmp(methodName, "init", 4) == 0) {
        if (methodName[4] == '\0') return YES; // It's just an init
        if (isupper(methodName[4]) || isdigit(methodName[4])) return YES; // It's init[A-Z0-9]
    }
    
    return NO;
}

// I could get rid of this <- Then why don't you?
const char *wax_removeProtocolEncodings(const char *type_descriptions) {
    switch (type_descriptions[0]) {
        case WAX_PROTOCOL_TYPE_CONST:
        case WAX_PROTOCOL_TYPE_INOUT:
        case WAX_PROTOCOL_TYPE_OUT:
        case WAX_PROTOCOL_TYPE_BYCOPY:
        case WAX_PROTOCOL_TYPE_BYREF:
        case WAX_PROTOCOL_TYPE_ONEWAY:
            return &type_descriptions[1];
            break;
        default:
            return type_descriptions;
            break;
    }
}

int wax_sizeOfTypeDescription(const char *full_type_description) {
    int index = 0;
    int size = 0;
    
    size_t length = strlen(full_type_description) + 1;
    char *type_description = alloca(length);
    bzero(type_description, length);
    wax_simplifyTypeDescription(full_type_description, type_description);
    
    while(type_description[index]) {
        switch (type_description[index]) {
            case WAX_TYPE_POINTER:
                size += sizeof(void *);
                
            case WAX_TYPE_CHAR:
                size += sizeof(char);
                break;
                
            case WAX_TYPE_INT:
                size += sizeof(int);
                break;
                
            case WAX_TYPE_ARRAY:
            case WAX_TYPE_ARRAY_END:
                [NSException raise:@"Wax Error" format:@"C array's are not implemented yet."];
                break;
            
            case WAX_TYPE_SHORT:
                size += sizeof(short);
                break;
                
            case WAX_TYPE_UNSIGNED_CHAR:
                size += sizeof(unsigned char);
                break;
                
            case WAX_TYPE_UNSIGNED_INT:
                size += sizeof(unsigned int);
                break;
                
            case WAX_TYPE_UNSIGNED_SHORT:
                size += sizeof(unsigned short);
                break;
                
            case WAX_TYPE_LONG:
                size += sizeof(long);
                break;
                
            case WAX_TYPE_LONG_LONG:
                size += sizeof(long long);
                break;
                
            case WAX_TYPE_UNSIGNED_LONG:
                size += sizeof(unsigned long);
                break;
                
            case WAX_TYPE_UNSIGNED_LONG_LONG:
                size += sizeof(unsigned long long);
                break;
                
            case WAX_TYPE_FLOAT:
                size += sizeof(float);
                break;
                
            case WAX_TYPE_DOUBLE:
                size += sizeof(double);
                break;
                
            case WAX_TYPE_C99_BOOL:
                size += sizeof(_Bool);
                break;
                
            case WAX_TYPE_STRING:
                size += sizeof(char *);
                break;
                
            case WAX_TYPE_VOID:
                size += sizeof(char);
                break;
                
            case WAX_TYPE_BITFIELD:
                [NSException raise:@"Wax Error" format:@"Bitfields are not implemented yet"];
                break;
                
            case WAX_TYPE_ID:
                size += sizeof(id);
                break;
                
            case WAX_TYPE_CLASS:
                size += sizeof(Class);
                break;
                
            case WAX_TYPE_SELECTOR:
                size += sizeof(SEL);
                break;
                
            case WAX_TYPE_STRUCT:
            case WAX_TYPE_STRUCT_END:
            case WAX_TYPE_UNION:
            case WAX_TYPE_UNION_END:
            case WAX_TYPE_UNKNOWN:                
            case WAX_PROTOCOL_TYPE_CONST:                
            case WAX_PROTOCOL_TYPE_IN:                
            case WAX_PROTOCOL_TYPE_INOUT:
            case WAX_PROTOCOL_TYPE_OUT:
            case WAX_PROTOCOL_TYPE_BYCOPY:
            case WAX_PROTOCOL_TYPE_BYREF:
            case WAX_PROTOCOL_TYPE_ONEWAY:                    
                // Weeeee! Just ignore this stuff I guess?
                break;
            default:
                [NSException raise:@"Wax Error" format:@"Unknown type encoding %c", type_description[index]];
                break;
        }
        
        index++;
    }
    
    return size;
}

int wax_simplifyTypeDescription(const char *in, char *out) {
    int out_index = 0;
    int in_index = 0;
    
    while(in[in_index]) {
        switch (in[in_index]) {
            case WAX_TYPE_STRUCT:
            case WAX_TYPE_UNION:                
                for (; in[in_index] != '='; in_index++); // Eat the name!
                in_index++; // Eat the = sign 
                break;
                
            case WAX_TYPE_ARRAY:            
                do {
                    out[out_index++] = in[in_index++];
                } while(in[in_index] != WAX_TYPE_ARRAY_END);
                break;
                
            case WAX_TYPE_POINTER: { //get rid of internal stucture parts
                out[out_index++] = in[in_index++]; 
                for (; in[in_index] == '^'; in_index++); // Eat all the pointers
                
                switch (in[in_index]) {
                    case WAX_TYPE_UNION:
                    case WAX_TYPE_STRUCT: {
                        in_index++;
                        int openCurlies = 1;
                        
                        for (; openCurlies > 1 || (in[in_index] != WAX_TYPE_UNION_END && in[in_index] != WAX_TYPE_STRUCT_END); in_index++) {
                            if (in[in_index] == WAX_TYPE_UNION || in[in_index] == WAX_TYPE_STRUCT) openCurlies++;
                            else if (in[in_index] == WAX_TYPE_UNION_END || in[in_index] == WAX_TYPE_STRUCT_END) openCurlies--;
                        }
                        break;
                    }
                }
            }
                
            case WAX_TYPE_STRUCT_END:
            case WAX_TYPE_UNION_END:
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
    
    out[out_index] = '\0';
    
    return out_index;
}

int wax_errorFunction(lua_State *L) {
    lua_getfield(L, LUA_GLOBALSINDEX, "debug");
    if (!lua_istable(L, -1)) {
        lua_pop(L, 1);
        return 1;
    }
    
    lua_getfield(L, -1, "traceback");
    if (!lua_isfunction(L, -1)) {
        lua_pop(L, 2);
        return 1;
    }    
    lua_remove(L, -2); // Remove debug
    
    lua_pushvalue(L, -2); // Grab the error string and place it on the stack
    
    lua_call(L, 1, 1);
    lua_remove(L, -2); // Remove original error string
    
    return 1;
}

int wax_pcall(lua_State *L, int argumentCount, int returnCount) {
    lua_pushcclosure(L, wax_errorFunction, 0);
    int errorFuncStackIndex = lua_gettop(L) - (argumentCount + 1); // Insert error function before arguments
    lua_insert(L, errorFuncStackIndex);
    
    return lua_pcall(L, argumentCount, returnCount, errorFuncStackIndex);
}

