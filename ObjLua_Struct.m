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
{"__newindex", __newindex},
{NULL, NULL}
};

static const struct luaL_Reg methods[] = {
{"pack", pack},
{NULL, NULL}
};

#define objlua_struct_encodeType(_type_) \
{ \
char *encoding = @encode(_type_); \
lua_pushstring(L, encoding); \
lua_setfield(L, -2, #_type_); \
} \

#define STRUCT_IS_A(_type_, _objLuaStruct_) strncmp(#_type_, &_objLuaStruct_->typeDescription[1], strlen(#_type_)) == 0

int luaopen_objlua_struct(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    luaL_newmetatable(L, OBJLUA_STRUCT_METATABLE_NAME);
    
    // Remember the typeDescriptions for certain structs!
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

ObjLua_Struct *objlua_struct_create(lua_State *L, const char *typeDescription, void *buffer) {
    BEGIN_STACK_MODIFY(L);
    
    size_t nbytes = sizeof(ObjLua_Struct);
    ObjLua_Struct *objLuaStruct = (ObjLua_Struct *)lua_newuserdata(L, nbytes);

    int size = objlua_size_of_type_description(typeDescription);
    
    objLuaStruct->data = malloc(size);
    memcpy(objLuaStruct->data, buffer, size);

    objLuaStruct->size = size;
    
    objLuaStruct->typeDescription = malloc(strlen(typeDescription) + 1);
    strcpy(objLuaStruct->typeDescription, typeDescription);
    
    // set the metatable
    luaL_getmetatable(L, OBJLUA_STRUCT_METATABLE_NAME);
    lua_setmetatable(L, -2);
    
    // give it a nice clean environment
    lua_newtable(L); 
    lua_setfenv(L, -2);
    lua_getfenv(L, -1);
    
    if (STRUCT_IS_A(CGRect, objLuaStruct)) { 
        CGRect *rect = (CGRect *)buffer;
        lua_pushstring(L, "x");
        lua_pushnumber(L, rect->origin.x);
        lua_rawset(L, -3);
        
        lua_pushstring(L, "y");
        lua_pushnumber(L, rect->origin.y);        
        lua_rawset(L, -3);
        
        lua_pushstring(L, "width");        
        lua_pushnumber(L, rect->size.width);
        lua_rawset(L, -3);
        
        lua_pushstring(L, "height");
        lua_pushnumber(L, rect->size.height);        
        lua_rawset(L, -3);
        
    }    
    else if (STRUCT_IS_A(CGPoint, objLuaStruct)) { 
        CGPoint *point = (CGPoint *)buffer;
        lua_pushstring(L, "x");
        lua_pushnumber(L, point->x);
        lua_rawset(L, -3);
        
        lua_pushstring(L, "y");
        lua_pushnumber(L, point->y);        
        lua_rawset(L, -3);

    }
    else if (STRUCT_IS_A(CGSize, objLuaStruct)) { 
        CGSize *size = (CGSize *)buffer;
        lua_pushstring(L, "width");        
        lua_pushnumber(L, size->width);
        lua_rawset(L, -3);
        
        lua_pushstring(L, "height");
        lua_pushnumber(L, size->height);        
        lua_rawset(L, -3);       
    }
    
    lua_pop(L, 1); // Pop env off the stack
    
    END_STACK_MODIFY(L, 1);
    
    return objLuaStruct;
}

int objlua_struct_refresh(lua_State *L, int stackindex) {
    BEGIN_STACK_MODIFY(L);
    
    ObjLua_Struct *objLuaStruct = (ObjLua_Struct *)luaL_checkudata(L, stackindex, OBJLUA_STRUCT_METATABLE_NAME);
    lua_getfenv(L, stackindex);
    
    if (STRUCT_IS_A(CGRect, objLuaStruct)) {
        CGRect *rect = (CGRect *)objLuaStruct->data;
        
        lua_getfield(L, -1, "x");
        rect->origin.x = lua_tonumber(L, -1);
        lua_pop(L, 1);        
        
        lua_getfield(L, -1, "y");
        rect->origin.y = lua_tonumber(L, -1);
        lua_pop(L, 1);        

        lua_getfield(L, -1, "width");
        rect->size.width = lua_tonumber(L, -1);
        lua_pop(L, 1);        

        lua_getfield(L, -1, "height");
        rect->size.height = lua_tonumber(L, -1);
        lua_pop(L, 1);                
    }    
    else if (STRUCT_IS_A(CGPoint, objLuaStruct)) { 
        CGPoint *point = (CGPoint *)objLuaStruct->data;
        
        lua_getfield(L, -1, "x");
        point->x = lua_tonumber(L, -1);
        lua_pop(L, 1);        
        
        lua_getfield(L, -1, "y");
        point->y = lua_tonumber(L, -1);
        lua_pop(L, 1);  
    }
    else if (STRUCT_IS_A(CGSize, objLuaStruct)) { 
        CGSize *size = (CGSize *)objLuaStruct->data;   
        
        lua_getfield(L, -1, "width");
        size->width = lua_tonumber(L, -1);
        lua_pop(L, 1);        
        
        lua_getfield(L, -1, "height");
        size->height = lua_tonumber(L, -1);
        lua_pop(L, 1);  
    }
    
    lua_pop(L, 1); // Pop the env off
    
    END_STACK_MODIFY(L, 0);
    
    return 1;
}

static int __index(lua_State *L) {
    luaL_checkudata(L, 1, OBJLUA_STRUCT_METATABLE_NAME);
    lua_getfenv(L, 1);
    lua_insert(L, -2);    
    lua_rawget(L, -2);
    
    return 1;
}

static int __newindex(lua_State *L) {
    luaL_checkudata(L, 1, OBJLUA_STRUCT_METATABLE_NAME);
    lua_getfenv(L, 1);
    lua_insert(L, -3);    
    lua_rawset(L, -3);
    
    return 0;
}

static int pack(lua_State *L) {
    // This can be a typeDescription or a Struct name... We store the struct names in the metatable
    luaL_getmetatable(L, OBJLUA_STRUCT_METATABLE_NAME);
    lua_pushvalue(L, 1);
    lua_rawget(L, -2);
    
    if (lua_isnil(L, -1)) {
        lua_pop(L, 2); // pop the nil and metatable off
    }
    else {
        lua_replace(L, 1);
        lua_pop(L, 1); // pop the metatable off
    }

    lua_pushcclosure(L, pack_closure, 1);
    return 1;
}

static int pack_closure(lua_State *L) {
    const char *typeDescription = lua_tostring(L, lua_upvalueindex(1));
    luaL_Buffer b;
    luaL_buffinit(L, &b);                
        
    char *simplifiedTypeDescription = calloc(sizeof(char *), strlen(typeDescription) + 1);
    objlua_simplify_type_description(typeDescription, simplifiedTypeDescription);
    
    for (int i = 0; simplifiedTypeDescription[i]; i++) {
        int size;
        int stackIndex = i + 1;
        
        if (stackIndex > lua_gettop(L)) {
            luaL_error(L, "Couldn't create struct with type description '%s'. Needs more than %d arguments.", typeDescription, lua_gettop(L) - 1);
        }
        
        void *value = objlua_to_objc(L, &simplifiedTypeDescription[i], stackIndex, &size);
        luaL_addlstring(&b, value, size );
        free(value);
    }
    luaL_pushresult(&b);
    free(simplifiedTypeDescription);
    
    objlua_struct_create(L, typeDescription, b.buffer);
    
    return 1;
}