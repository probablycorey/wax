//
//  ObjLua_Struct.m
//  Rentals
//
//  Created by ProbablyInteractive on 7/7/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "ObjLua_Struct.h"
#import "ObjLua_Helpers.h"

#import "lua.h"
#import "lauxlib.h"


static const struct luaL_Reg metaMethods[] = {
{"__index", __index},
{NULL, NULL}
};

static const struct luaL_Reg methods[] = {
{"pack", pack},
{NULL, NULL}
};

#define objlua_struct_encodeType(_type_) \
{ \
char *encoding = @encode(_type_); \
char *simplified_encoding = calloc(sizeof(char *), strlen(encoding) + 1); \
objlua_simplify_type_encoding(encoding, simplified_encoding); \
lua_pushstring(L, simplified_encoding); \
lua_setfield(L, -2, #_type_); \
free(simplified_encoding); \
} \

int luaopen_objlua_struct(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    luaL_newmetatable(L, OBJLUA_STRUCT_METATABLE_NAME);
    
    objlua_struct_encodeType(CGRect)
    objlua_struct_encodeType(CGPoint)
    objlua_struct_encodeType(CGSize)
    
    luaL_register(L, NULL, metaMethods);
    luaL_register(L, OBJLUA_STRUCT_METATABLE_NAME, methods);    
    
    lua_pushvalue(L, -2);
    lua_setmetatable(L, -2); // Set the metatable for the struct module
    
    END_STACK_MODIFY(L, 0);
    return 1;
}

static int pack(lua_State *L) {
    lua_pushcclosure(L, pack_closure, 1);  
    
    return 1;
}

static int __index(lua_State *L) {
    luaL_getmetatable(L, OBJLUA_STRUCT_METATABLE_NAME);
    lua_pushvalue(L, -2);
    lua_gettable(L, -2);
    
    if (!lua_isnil(L, -1)) {
        lua_pushcclosure(L, pack_closure, 1);  
    }

    return 1;
}

static int pack_closure(lua_State *L) {
    luaL_Buffer b;
    luaL_buffinit(L, &b);                
    
    const char *type_description = lua_tostring(L, lua_upvalueindex(1));
    for (int i = 0; type_description[i]; i++) {
        int size;
        void *value = objlua_to_objc(L, &type_description[i], i + 1, &size);
        luaL_addlstring(&b, value, size );
        free(value);
    }

    luaL_pushresult(&b);
    
    return 1;
}
