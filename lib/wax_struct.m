//
//  wax_struct_userdata.m
//  Rentals
//
//  Created by ProbablyInteractive on 7/7/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "wax_struct.h"
#import "wax_helpers.h"

#import "lua.h"
#import "lauxlib.h"

#define LABELED_STRUCT_TABLE_NAME "labeledStructs"

static int __index(lua_State *L);
static int __newindex(lua_State *L);
static int __tostring(lua_State *L);
static int __gc(lua_State *L);

static int copy(lua_State *L);
static int create(lua_State *L);
static int unpack(lua_State *L);
static int pack(lua_State *L);

static int createClosure(lua_State *L);

static const struct luaL_Reg metaFunctions[] = {
{"__index", __index},
{"__newindex", __newindex},
{"__tostring", __tostring},
{"__gc", __gc},
{NULL, NULL}
};

static const struct luaL_Reg functions[] = {
{"copy", copy},
{"create", create},
{"pack", pack},
{"unpack", unpack},
{NULL, NULL}
};

int luaopen_wax_struct(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    luaL_newmetatable(L, WAX_STRUCT_METATABLE_NAME);
    
    luaL_register(L, NULL, metaFunctions);
    luaL_register(L, WAX_STRUCT_METATABLE_NAME, functions);    

    // metatable stores all the labeled structs and their mappings
    luaL_getmetatable(L, WAX_STRUCT_METATABLE_NAME);    
    lua_newtable(L);
    lua_setfield(L, -2, LABELED_STRUCT_TABLE_NAME);
    
    END_STACK_MODIFY(L, 0);
    return 1;
}

wax_struct_userdata *wax_struct_create(lua_State *L, const char *typeDescription, void *buffer) {
    BEGIN_STACK_MODIFY(L);
    
    size_t nbytes = sizeof(wax_struct_userdata);
    wax_struct_userdata *structUserdata = (wax_struct_userdata *)lua_newuserdata(L, nbytes);

    int size = wax_sizeOfTypeDescription(typeDescription);
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
    luaL_getmetatable(L, WAX_STRUCT_METATABLE_NAME);
    lua_setmetatable(L, -2);
    
    // give it a nice clean environment
    lua_newtable(L); 
    lua_setfenv(L, -2);
    
    END_STACK_MODIFY(L, 1)
    
    return structUserdata;
}

// Maybe all this data should be created at wax_struct_userdata creation time? I think so!
void wax_struct_pushValueAt(lua_State *L, wax_struct_userdata *structUserdata, int offset) {
    char *simplifiedTypeDescription = alloca(strlen(structUserdata->typeDescription) + 1);
    wax_simplifyTypeDescription(structUserdata->typeDescription, simplifiedTypeDescription);
    
    int position = 0;
    char type[2] = {simplifiedTypeDescription[0], '\0'};    
    for (int i = 1; i < offset; i++) {
        position += wax_sizeOfTypeDescription(type);
        type[0] = simplifiedTypeDescription[i];
    }
    
    wax_fromObjc(L, type, structUserdata->data + position);
}

void wax_struct_setValueAt(lua_State *L, wax_struct_userdata *structUserdata, int offset, int stackIndex) {
    char *simplifiedTypeDescription = alloca(strlen(structUserdata->typeDescription) + 1);
    wax_simplifyTypeDescription(structUserdata->typeDescription, simplifiedTypeDescription);
    
    int position = 0;
    char type[2] = {simplifiedTypeDescription[0], '\0'};    
    for (int i = 1; i < offset; i++) {
        position += wax_sizeOfTypeDescription(type);
        type[0] = simplifiedTypeDescription[i];
    }
    
    int size;
    void *value = wax_copyToObjc(L, type, stackIndex, &size);
    memcpy(structUserdata->data + position, value, size);
    free(value);
}

int wax_struct_getOffsetForName(lua_State *L, wax_struct_userdata *structUserdata, const char *name) {
    BEGIN_STACK_MODIFY(L);
    
    // Get the labeled struct table
    luaL_getmetatable(L, WAX_STRUCT_METATABLE_NAME);    
    lua_getfield(L, -1, LABELED_STRUCT_TABLE_NAME);
    lua_getfield(L, -1, structUserdata->name);
    
    if (lua_isnil(L, -1)) {
        luaL_error(L, "No struct mapping for '%s'", structUserdata->name);
    }
    
    lua_getfield(L, -1, name);
    if (lua_isnil(L, -1)) {
        luaL_error(L, "No mapping for varible named '%s' for struct '%s'", name, structUserdata->name);
    }
    
    int offset = lua_tonumber(L, -1);
    
    END_STACK_MODIFY(L, 0);
    
    return offset;
}

static int __index(lua_State *L) {
    wax_struct_userdata *structUserdata = (wax_struct_userdata *)luaL_checkudata(L, 1, WAX_STRUCT_METATABLE_NAME);
    
    int offset;
    if (lua_isnumber(L, 2)) {
        offset = lua_tonumber(L, 2);
    }
    else {
        const char *name = lua_tostring(L, 2);        
        offset = wax_struct_getOffsetForName(L, structUserdata, name);
    }
    
    wax_struct_pushValueAt(L, structUserdata, offset);
    
    return 1;
}

static int __newindex(lua_State *L) {
    wax_struct_userdata *structUserdata = (wax_struct_userdata *)luaL_checkudata(L, 1, WAX_STRUCT_METATABLE_NAME);
    const char *name = lua_tostring(L, 2);

    int offset = wax_struct_getOffsetForName(L, structUserdata, name);
    wax_struct_setValueAt(L, structUserdata, offset, 3);

    return 0;
}

static int __gc(lua_State *L) {
    wax_struct_userdata *structUserdata = (wax_struct_userdata *)luaL_checkudata(L, 1, WAX_STRUCT_METATABLE_NAME);    

    free(structUserdata->data);
    free(structUserdata->name);
    free(structUserdata->typeDescription);
    return 0;
}


static int __tostring(lua_State *L) {    
    wax_struct_userdata *structUserdata = (wax_struct_userdata *)luaL_checkudata(L, 1, WAX_STRUCT_METATABLE_NAME);
    lua_getmetatable(L, -1);
    lua_getfield(L, -1, LABELED_STRUCT_TABLE_NAME);
    lua_getfield(L, -1, structUserdata->name);
    
    if (lua_isnil(L, -1)) {
        lua_pushstring(L, "wax struct");
    }
    else {
        luaL_Buffer b;
        luaL_buffinit(L, &b);
        luaL_addstring(&b, structUserdata->name);
        luaL_addstring(&b, " {\n");
        
        lua_pushnil(L); // First key
        while (lua_next(L, -2)) {
            luaL_addstring(&b, "\t");               
            luaL_addstring(&b, lua_tostring(L, -2));
            luaL_addstring(&b, " : ");
            
            wax_struct_pushValueAt(L, structUserdata, lua_tonumber(L, -1));
            luaL_addstring(&b, lua_tostring(L, -1));
                                   
            luaL_addstring(&b, "\n");
            lua_pop(L, 2); // pops the value and the struct offset, keeps the key for the next iteration
        }
        
        luaL_addstring(&b, "}");
        
        luaL_pushresult(&b);
    }
    
    return 1;
}

static int copy(lua_State *L) {
    wax_struct_userdata *structUserdata = (wax_struct_userdata *)luaL_checkudata(L, 1, WAX_STRUCT_METATABLE_NAME);
    wax_struct_userdata *newStructUserdata = wax_struct_create(L, structUserdata->typeDescription, structUserdata->data);
    
    int size = strlen(structUserdata->name);
    newStructUserdata->name = calloc(sizeof(char *), size + 1); // add 1 for '\0'
    strncpy(newStructUserdata->name, structUserdata->name,  size);            
    
    return 1;
}

static int create(lua_State *L) {
    const char *name = lua_tostring(L, 1);
    int mappingOffset = 2;
    int mappingsCount = lua_gettop(L) - 2;
    
    // Get the labeled struct table
    luaL_getmetatable(L, WAX_STRUCT_METATABLE_NAME);    
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
    wax_struct_userdata *structUserdata = (wax_struct_userdata *)luaL_checkudata(L, 1, WAX_STRUCT_METATABLE_NAME);
    
    char *simplifiedTypeDescription = alloca(strlen(structUserdata->typeDescription) + 1);
    wax_simplifyTypeDescription(structUserdata->typeDescription, simplifiedTypeDescription);
    
    lua_newtable(L);
    
    int index = 0;
    int position = 0;
    char type[2] = {'\0', '\0'};    
    while((type[0] = simplifiedTypeDescription[index])) {         
        wax_fromObjc(L, type, structUserdata->data + position);
        lua_rawseti(L, -2, index + 1);
        position += wax_sizeOfTypeDescription(type);
        index++;
    }
    
    return 1;
}

// ENCODINGS CAN BE FOUND AT http://developer.apple.com/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
static int pack(lua_State *L) {
    const char *typeDescription = lua_tostring(L, 1);

    char *simplifiedTypeDescription = alloca(strlen(typeDescription) + 1);
    wax_simplifyTypeDescription(typeDescription, simplifiedTypeDescription);

    if (strlen(simplifiedTypeDescription) != lua_gettop(L) - 1) {
        luaL_error(L, "Couldn't pack struct. Received %d arguments for struct with type description '%s' (should have received %d)", lua_gettop(L) - 1, typeDescription, strlen(simplifiedTypeDescription));
    }    
    
    luaL_Buffer b;
    luaL_buffinit(L, &b);
    
    for (int i = 0; simplifiedTypeDescription[i]; i++) {
        int size;
        int stackIndex = i + 2; // start at 2 (1 is where the type description is)
        
        void *value = wax_copyToObjc(L, &simplifiedTypeDescription[i], stackIndex, &size);
        luaL_addlstring(&b, value, size);
        free(value);
    }
    luaL_pushresult(&b);
    
    wax_struct_create(L, typeDescription, b.buffer);
    
    return 1;
}

// upvalues (string name, string typeDescription)
static int createClosure(lua_State *L) {
    const char *name = lua_tostring(L, lua_upvalueindex(1));
    lua_pushvalue(L, lua_upvalueindex(2)); // Push type description
    lua_insert(L, 1);

    pack(L); // Creates the userdata for us...    
    
    // Set the name for the structUserdata (Make this automatic in the future!)
    wax_struct_userdata *structUserdata = (wax_struct_userdata *)lua_touserdata(L, -1);
    if (!structUserdata->name) {    
        structUserdata->name = malloc(strlen(name) + 1);
        strcpy(structUserdata->name, name);
    }

    return 1;
}   