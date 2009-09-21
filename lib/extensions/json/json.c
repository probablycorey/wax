#include "json.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>

#include "lua.h"
#include "lauxlib.h"

// Code needed by the generated parser
// -----------------------------------
static const char *json_input;
static int json_pos = 0;
static int json_line = 1;
static lua_State *json_L;

#define YY_PARSE(T) static T
#define YY_INPUT(buf, result, max_size) \
{ \
int letter = json_input[json_pos++]; \
if ('\n' == json_input[json_pos] || '\r' == json_input[json_pos]) { \
if ('\r' == json_input[json_pos] && '\n' == json_input[json_pos+1]) json_pos++; \
json_pos++; \
json_line++; \
} \
result = (EOF == letter) ? 0 : (*(buf) = letter, 1); \
}

void json_pushString(char *string) {
    lua_pushstring(json_L, string);
}

void json_pushNumber(double number) {
    lua_pushnumber(json_L, number);
}

void json_pushBoolean(bool value) {
    lua_pushboolean(json_L, value);
}

void json_pushNil() {
    lua_pushnil(json_L);
}

void json_newArray() {
    lua_newtable(json_L);
}

void json_newHash() {
    lua_newtable(json_L);
}

void json_addToHash() {
    lua_rawset(json_L, -3);
}

void json_addToArray() {
    lua_rawseti(json_L, -2, lua_objlen(json_L, -2) + 1);
}

#include "json.peg.h" // Import the peg parsing code

// Parsing code
// ------------
void json_error(char *message) {
    fprintf(stderr, "%s: Line %d", message, json_line);
    if (yytext[0]) fprintf(stderr, " near token '%s'", yytext);
    
    if (json_input[json_pos]) {
        fprintf(stderr, " near text \n");
        
        int pos = json_pos;
        
        while (json_input[pos] && json_input[pos] != '\r' && json_input[pos] != '\n') {
            fputc(json_input[pos], stderr);
            pos++;
        }
        
        putc('\n', stderr);
    }

    printf("\n");
    luaL_error(json_L, "Couldn't parse json.\n %s", json_input);
}

void json_parseString(lua_State *L, const char *input) {  
    json_input = input;
    json_pos = yybuflen = 0;  
    json_L = L;
    
    if(!yyparse()) {
        json_error("JSON Parsing Error");
    }
}

static const struct luaL_Reg metaFunctions[] = {
    {NULL, NULL}
};

static const struct luaL_Reg functions[] = {
    {"parse", parse},
    {NULL, NULL}
};

static int parse(lua_State *L) {
    json_parseString(L, lua_tostring(L, -1));
    
    return 1;
}

int luaopen_json(lua_State *L) {    
    luaL_newmetatable(L, JSON_METATABLE_NAME);        
    luaL_register(L, NULL, metaFunctions);
    luaL_register(L, JSON_METATABLE_NAME, functions);    
    
    return 1;
}