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

#define LABELED_STRUCT_TABLE_NAME "labeledStructs"

static const struct luaL_Reg metaFunctions[] = {
{"__index", __index},
{"__newindex", __newindex},
{"__tostring", __tostring},
{NULL, NULL}
};

static const struct luaL_Reg functions[] = {
{"create", create},
{"pack", pack},
{"unpack", unpack},
{NULL, NULL}
};

int luaopen_oink_struct(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    luaL_newmetatable(L, OINK_STRUCT_METATABLE_NAME);
    
    luaL_register(L, NULL, metaFunctions);
    luaL_register(L, OINK_STRUCT_METATABLE_NAME, functions);    

    // metatable stores all the labeled structs and their mappings
    luaL_getmetatable(L, OINK_STRUCT_METATABLE_NAME);    
    lua_newtable(L);
    lua_setfield(L, -2, LABELED_STRUCT_TABLE_NAME);
    
    END_STACK_MODIFY(L, 0);
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
    
    structUserdata->name = nil;
    
    if (typeDescription[0] == '{') { // We can get a name from the type desciption
        char *endLocation = strchr(&typeDescription[1], '='); 
        if (endLocation) {
            int size = endLocation - &typeDescription[1];
            structUserdata->name = calloc(sizeof(char *), size + 1); // add 1 for '\0'
            strncpy(structUserdata->name, &typeDescription[1], size);            
        }
    }
    
    // set the metatable
    luaL_getmetatable(L, OINK_STRUCT_METATABLE_NAME);
    lua_setmetatable(L, -2);
    
    // give it a nice clean environment
    lua_newtable(L); 
    lua_setfenv(L, -2);
    
    END_STACK_MODIFY(L, 1)
    
    return structUserdata;
}

void oink_struct_pushValueAt(lua_State *L, oink_struct_userdata *structUserdata, int index) {
    char *simplifiedTypeDescription = alloca(strlen(structUserdata->typeDescription) + 1);
    oink_simplifyTypeDescription(structUserdata->typeDescription, simplifiedTypeDescription);
    
    int position = 0;
    char type[2] = {simplifiedTypeDescription[0], '\0'};    
    for (int i = 1; i < index; i++) {
        position += oink_sizeOfTypeDescription(type);
        type[0] = simplifiedTypeDescription[i];
    }
    
    oink_fromObjc(L, type, structUserdata->data + position);
}

static int __index(lua_State *L) {
    oink_struct_userdata *structUserdata = (oink_struct_userdata *)luaL_checkudata(L, 1, OINK_STRUCT_METATABLE_NAME);
    const char *name = lua_tostring(L, 2);
    
    // Get the labeled struct table
    luaL_getmetatable(L, OINK_STRUCT_METATABLE_NAME);    
    lua_getfield(L, -1, LABELED_STRUCT_TABLE_NAME);
    lua_getfield(L, -1, structUserdata->name);

    if (lua_isnil(L, -1)) {
        luaL_error(L, "No struct mapping for '%s'", structUserdata->name);
    }

    lua_getfield(L, -1, name);
    if (lua_isnil(L, -1)) {
        luaL_error(L, "No mapping for varible named '%s' for struct '%s'", name, structUserdata->name);
    }

    int index = lua_tonumber(L, -1);
    oink_struct_pushValueAt(L, structUserdata, index);
    
    return 1;
}

static int __newindex(lua_State *L) {
//    oink_struct_userdata *structUserdata = (oink_struct_userdata *)luaL_checkudata(L, 1, OINK_STRUCT_METATABLE_NAME);
//    lua_getfenv(L, 1);
//    lua_insert(L, -3);    
//    lua_rawset(L, -3);
    
    return 0;
}

static int __gc(lua_State *L) {
    oink_struct_userdata *structUserdata = (oink_struct_userdata *)luaL_checkudata(L, 1, OINK_STRUCT_METATABLE_NAME);    
    NSLog(@"STRUCT NAMED %s is GOING AWAY", structUserdata->name);
    //    oink_struct_userdata *structUserdata = (oink_struct_userdata *)luaL_checkudata(L, 1, OINK_STRUCT_METATABLE_NAME);
    //    lua_getfenv(L, 1);
    //    lua_insert(L, -3);    
    //    lua_rawset(L, -3);
    
    return 0;
}


static int __tostring(lua_State *L) {	
    luaL_checkudata(L, 1, OINK_STRUCT_METATABLE_NAME);
	lua_pushstring(L, "oink struct");
	
	return 1;
}

static int create(lua_State *L) {
    const char *name = lua_tostring(L, 1);
    int mappingOffset = 2;
    int mappingsCount = lua_gettop(L) - 2;
    
    // Get the labeled struct table
    luaL_getmetatable(L, OINK_STRUCT_METATABLE_NAME);    
    lua_getfield(L, -1, LABELED_STRUCT_TABLE_NAME);
    
    lua_pushstring(L, name);
    lua_newtable(L); // create new mapping table for this labeled struct
    for (int i = 1; i <= mappingsCount; i++) {
        int stackIndex = i + mappingOffset;
        lua_pushvalue(L, stackIndex); // push the mapping name
        lua_pushnumber(L, i); // Location of the name in the struct
        lua_rawset(L, -3);
    }
    
    lua_rawset(L, -3);
    
    lua_pushvalue(L, 1); // Push the struct name (So it can be indexed via the mapping table)
    lua_pushvalue(L, 2); // Push the type description
    lua_pushcclosure(L, createClosure, 2);
    lua_setglobal(L, name);
    
    return 0;
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


// ENCODINGS CAN BE FOUND AT http://developer.apple.com/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
static int pack(lua_State *L) {
    const char *typeDescription = lua_tostring(L, 1);

    char *simplifiedTypeDescription = alloca(strlen(typeDescription) + 1);
    oink_simplifyTypeDescription(typeDescription, simplifiedTypeDescription);

    if (strlen(simplifiedTypeDescription) != lua_gettop(L) - 1) {
        luaL_error(L, "Couldn't pack struct. Received %d arguments for struct with type description '%s' (should have received %d)", lua_gettop(L) - 1, typeDescription, strlen(simplifiedTypeDescription));
    }    
    
    luaL_Buffer b;
    luaL_buffinit(L, &b);
    
    for (int i = 0; simplifiedTypeDescription[i]; i++) {
        int size;
        int stackIndex = i + 2; // start at 2 (1 is where the type description is)
        
        void *value = oink_copyToObjc(L, &simplifiedTypeDescription[i], stackIndex, &size);
        luaL_addlstring(&b, value, size);
        free(value);
    }
    luaL_pushresult(&b);
    
    oink_struct_create(L, typeDescription, b.buffer);
    
    return 1;
}

// upvalues (string name, string typeDescription)
static int createClosure(lua_State *L) {
    const char *name = lua_tostring(L, lua_upvalueindex(1));
    lua_pushvalue(L, lua_upvalueindex(2)); // Push type description
    lua_insert(L, 1);

    pack(L); // Creates the userdata for us...    
    
    // Set the name for the structUserdata (Make this automatic in the future!)
    oink_struct_userdata *structUserdata = (oink_struct_userdata *)lua_touserdata(L, -1);
    if (!structUserdata->name) {    
        structUserdata->name = malloc(strlen(name) + 1);
        strcpy(structUserdata->name, name);
    }

    return 1;
}