//
//  oink_struct_userdata.m
//  Rentals
//
//  Created by ProbablyInteractive on 7/7/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "oink_struct.h"
#import "oink_helpers.h"

#import "lua.h"
#import "lauxlib.h"

static const struct luaL_Reg metaFunctions[] = {
{"__index", __index},
{"__newindex", __newindex},
{"__tostring", __tostring},
{NULL, NULL}
};

static const struct luaL_Reg functions[] = {
{"pack", pack},
{"unpack", unpack},
{NULL, NULL}
};

#define ENCODE_TYPE(_type_) \
{ \
char *encoding = @encode(_type_); \
lua_pushstring(L, encoding); \
lua_setfield(L, -2, #_type_); \
} \

#define STRUCT_IS_A(_type_, _structUserdata_) strncmp(#_type_, &_structUserdata_->typeDescription[1], strlen(#_type_)) == 0

int luaopen_oink_struct(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    luaL_newmetatable(L, OINK_STRUCT_METATABLE_NAME);
    
    // Remember the typeDescriptions for certain structs!
    ENCODE_TYPE(CGRect)
    ENCODE_TYPE(CGPoint)
    ENCODE_TYPE(CGSize)
	ENCODE_TYPE(NSRange)
    
    luaL_register(L, NULL, metaFunctions);
    luaL_register(L, OINK_STRUCT_METATABLE_NAME, functions);    
    
    lua_pushvalue(L, -2);
    lua_setmetatable(L, -2); // Set the metatable for the struct module
    
    END_STACK_MODIFY(L, 0)
    return 1;
}

oink_struct_userdata *oink_struct_create(lua_State *L, const char *typeDescription, void *buffer) {
    BEGIN_STACK_MODIFY(L);
    
    size_t nbytes = sizeof(oink_struct_userdata);
    oink_struct_userdata *structUserdata = (oink_struct_userdata *)lua_newuserdata(L, nbytes);

    int size = oink_sizeOfTypeDescription(typeDescription);
    
    structUserdata->data = malloc(size);
    memcpy(structUserdata->data, buffer, size);

    structUserdata->size = size;
    
    structUserdata->typeDescription = malloc(strlen(typeDescription) + 1);
    strcpy(structUserdata->typeDescription, typeDescription);
    
    // set the metatable
    luaL_getmetatable(L, OINK_STRUCT_METATABLE_NAME);
    lua_setmetatable(L, -2);
    
    // give it a nice clean environment
    lua_newtable(L); 
    lua_setfenv(L, -2);
    lua_getfenv(L, -1);
    
    if (STRUCT_IS_A(CGRect, structUserdata)) { 
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
    else if (STRUCT_IS_A(CGPoint, structUserdata)) { 
        CGPoint *point = (CGPoint *)buffer;
        lua_pushstring(L, "x");
        lua_pushnumber(L, point->x);
        lua_rawset(L, -3);
        
        lua_pushstring(L, "y");
        lua_pushnumber(L, point->y);        
        lua_rawset(L, -3);

    }
    else if (STRUCT_IS_A(CGSize, structUserdata)) { 
        CGSize *size = (CGSize *)buffer;
        lua_pushstring(L, "width");        
        lua_pushnumber(L, size->width);
        lua_rawset(L, -3);
        
        lua_pushstring(L, "height");
        lua_pushnumber(L, size->height);        
        lua_rawset(L, -3);       
    }
	else if (STRUCT_IS_A(NSRange, structUserdata)) { 
        NSRange *range = (NSRange *)buffer;
        lua_pushstring(L, "location");        
        lua_pushnumber(L, range->location);
        lua_rawset(L, -3);
        
        lua_pushstring(L, "length");
        lua_pushnumber(L, range->length);        
        lua_rawset(L, -3);       
    }
    
    lua_pop(L, 1); // Pop env off the stack
    
    END_STACK_MODIFY(L, 1)
    
    return structUserdata;
}

static int __index(lua_State *L) {
    luaL_checkudata(L, 1, OINK_STRUCT_METATABLE_NAME);
    lua_getfenv(L, 1);
    lua_insert(L, -2);    
    lua_rawget(L, -2);
    
    return 1;
}

static int __newindex(lua_State *L) {
    luaL_checkudata(L, 1, OINK_STRUCT_METATABLE_NAME);
    lua_getfenv(L, 1);
    lua_insert(L, -3);    
    lua_rawset(L, -3);
    
    return 0;
}

static int __tostring(lua_State *L) {	
    luaL_checkudata(L, 1, OINK_STRUCT_METATABLE_NAME);
	lua_pushstring(L, "oink struct");
	
	return 1;
}

static int unpack(lua_State *L) {
    oink_struct_userdata *structUserdata = (oink_struct_userdata *)luaL_checkudata(L, 1, OINK_STRUCT_METATABLE_NAME);
    
    char *simplifiedTypeDescription = alloca(strlen(structUserdata->typeDescription) + 1);
    oink_simplifyTypeDescription(structUserdata->typeDescription, simplifiedTypeDescription);
    
    lua_newtable(L);
    
    int index = 0;
    int position = 0;
    char type[2] = {'\0', '\0'};    
    while(type[0] = simplifiedTypeDescription[index]) {         
        oink_fromObjc(L, type, structUserdata->data + position);
        lua_rawseti(L, -2, index + 1);
        position += oink_sizeOfTypeDescription(type);
        index++;
    }
    
    return 1;
}

static int pack(lua_State *L) {
    // This can be a typeDescription or a Struct name... We store the struct names in the metatable
    luaL_getmetatable(L, OINK_STRUCT_METATABLE_NAME);
    lua_pushvalue(L, 1);
    lua_rawget(L, -2);
    
    if (lua_isnil(L, -1)) {
        lua_pop(L, 2); // pop the nil and metatable off
    }
    else {
        lua_replace(L, 1);
        lua_pop(L, 1); // pop the metatable off
    }

    lua_pushcclosure(L, packClosure, 1);
    return 1;
}

static int packClosure(lua_State *L) {
    const char *typeDescription = lua_tostring(L, lua_upvalueindex(1));
    luaL_Buffer b;
    luaL_buffinit(L, &b);                
        
    char *simplifiedTypeDescription = calloc(sizeof(char *), strlen(typeDescription) + 1);
    oink_simplifyTypeDescription(typeDescription, simplifiedTypeDescription);
    
    for (int i = 0; simplifiedTypeDescription[i]; i++) {
        int size;
        int stackIndex = i + 1;
        
        if (stackIndex > lua_gettop(L)) {
            luaL_error(L, "Couldn't create struct with type description '%s'. Needs more than %d arguments.", typeDescription, lua_gettop(L) - 1);
        }
        void *value = oink_copyToObjc(L, &simplifiedTypeDescription[i], stackIndex, &size);
        luaL_addlstring(&b, value, size );
        free(value);
    }
    luaL_pushresult(&b);
    free(simplifiedTypeDescription);
    
    oink_struct_create(L, typeDescription, b.buffer);
    
    return 1;
}