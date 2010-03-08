#ifndef json_h
#define json_h

#import "lua.h"

#define JSON_METATABLE_NAME "wax.json"

int luaopen_wax_json(lua_State *L);
static int parse(lua_State *L);
static int generate(lua_State *L);

void json_parseString(lua_State *L, const char *input);

#endif