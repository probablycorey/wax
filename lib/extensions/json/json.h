#ifndef json_h
#define json_h

#import "lua.h"

#define JSON_METATABLE_NAME "json"

int luaopen_json(lua_State *L);
static int parse(lua_State *L);

void json_parseString(lua_State *L, const char *input);

#endif