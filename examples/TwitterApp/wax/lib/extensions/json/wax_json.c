#include "wax_json.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>

#include "lua.h"
#include "lauxlib.h"

static int parse(lua_State *L);
static int generate(lua_State *L);

static const struct luaL_Reg metaFunctions[] = {
    {NULL, NULL}
};

static const struct luaL_Reg functions[] = {
    {"parse", parse},
    {"generate", generate},
    {NULL, NULL}
};

int luaopen_wax_json(lua_State *L) {    
    luaL_newmetatable(L, JSON_METATABLE_NAME);        
    luaL_register(L, NULL, metaFunctions);
    luaL_register(L, JSON_METATABLE_NAME, functions);    
    
    lua_pop(L, 2); // Remove tables from stack,
    
    return 0;
}

#include "yajl/yajl_parse.h"
#include "yajl/yajl_lex.h"
#include "yajl/yajl_parser.h"
#include "yajl/yajl_bytestack.h"
#include "yajl/yajl_gen.h"
#include <string.h>

static yajl_gen gen;
static yajl_handle hand;
static yajl_bytestack state;
enum {
    state_begin,
    state_array,
    state_hash
};

void push_hash_or_array(lua_State *L) {
    switch (yajl_bs_current(state)) {
        case state_hash:
            lua_rawset(L, -3);
            break;
        case state_array:
            lua_rawseti(L, -2, lua_objlen(L, -2) + 1);
            break;
    }
}

static int push_null(void *ctx) {
    lua_State *L = (lua_State *) ctx;
    lua_pushnil(L);
    push_hash_or_array(L);
    return 1;
}

static int push_boolean(void *ctx, int boolean) {
    lua_State *L = (lua_State *) ctx;
    lua_pushboolean(L, boolean ? true : false);
    push_hash_or_array(L);
    return 1;
}

static int push_integer(void *ctx, long num) {
    lua_State *L = (lua_State *) ctx;
    lua_pushinteger(L, num);
    push_hash_or_array(L);
    return 1;
}

static int push_double(void *ctx, double num) {
    lua_State *L = (lua_State *) ctx;
    lua_pushnumber(L, num);
    push_hash_or_array(L);
    return 1;
}

static int push_string(void *ctx, const unsigned char *string, unsigned int len) {
    lua_State *L = (lua_State *) ctx;
    lua_pushlstring(L, (const char *)string, len);
    push_hash_or_array(L);
    return 1;
}

static int push_start_map(void *ctx) {
    lua_State *L = (lua_State *) ctx;
    yajl_bs_push(state, state_hash);
    lua_newtable(L);
    return 1;
}

static int push_map_key(void *ctx, const unsigned char *string, unsigned int len) {
    lua_State *L = (lua_State *) ctx;
    lua_pushlstring(L, (const char *)string, len);
    return 1;
}

static int push_end_map(void *ctx) {
    lua_State *L = (lua_State *) ctx;
    yajl_bs_pop(state);
    push_hash_or_array(L);
    return 1;
}

static int push_start_array(void *ctx) {
    lua_State *L = (lua_State *) ctx;
    yajl_bs_push(state, state_array);
    lua_newtable(L);
    return 1;
}

static int push_end_array(void *ctx) {
    lua_State *L = (lua_State *) ctx;
    yajl_bs_pop(state);
    push_hash_or_array(L);
    return 1;
}

static yajl_callbacks callbacks = {
    push_null,
    push_boolean,
    push_integer,
    push_double,
    NULL,
    push_string,
    push_start_map,
    push_map_key,
    push_end_map,
    push_start_array,
    push_end_array
};

static int parse_string(lua_State *L, const unsigned char* input, unsigned int len) {
    yajl_parser_config cfg = { .allowComments = 1, .checkUTF8 = 0 };
    yajl_status stat;
    unsigned char* error = NULL;
    char buffer[1024];

    hand = yajl_alloc(&callbacks, &cfg, NULL, (void *) L);
    yajl_bs_init(state, &(hand->alloc));
    yajl_bs_push(state, state_begin);

    stat = yajl_parse(hand, input, len);
    if (stat == yajl_status_ok || stat == yajl_status_insufficient_data) {
        stat = yajl_parse_complete(hand);
    }

    if (stat != yajl_status_ok) {
        error = yajl_get_error(hand, 1, input, len);
        strncpy(buffer, (const char *)error, 1024);
        yajl_free_error(hand, error);
        yajl_bs_free(state);
        yajl_free(hand);
        lua_pushstring(L, "ERROR: Could not parse JSON string");
    } else {
        yajl_bs_free(state);
        yajl_free(hand);
    }

    return 1;
}

static int parse(lua_State *L) {
    size_t len;
    const char *input = lua_tolstring(L, -1, &len);

    if (!input) {
		lua_pushstring(L, "ERROR: Could not parse JSON string");
		return 1;
	}
	
	// Nothing to parse!
	if (len == 0) {
		lua_pushnil(L);
		return 1;
	}

    return parse_string(L, (const unsigned char *)input, len);
}

void json_parseString(lua_State *L, const char *input) {
    parse_string(L, (const unsigned char *)input, strlen(input));
}

void generate_value(yajl_gen gen, lua_State *L) {
    yajl_gen_status stat;
    int type = lua_type(L, -1);

    switch (type) {
        case LUA_TNIL:
        case LUA_TNONE:
            stat = yajl_gen_null(gen);
            break;

        case LUA_TBOOLEAN:
            stat = yajl_gen_bool(gen, lua_toboolean(L, -1));
            break;

        case LUA_TNUMBER:
        case LUA_TSTRING: {
            size_t len;
            const char *str;

            if (type == LUA_TNUMBER) {
                lua_pushvalue(L, -1); // copy of the number
                str = lua_tolstring(L, -1, &len); // converts value on stack to a string
                lua_pop(L, 1); // pop off copy
                stat = yajl_gen_number(gen, str, (unsigned int)len);
            } else {
                str = lua_tolstring(L, -1, &len);
                stat = yajl_gen_string(gen, (const unsigned char*)str, (unsigned int)len);
            }
            break;
        }

        case LUA_TTABLE: {
            bool dictionary = false;
            bool empty = true;

            lua_pushvalue(L, -1); // Push the table reference on the top
            lua_pushnil(L);  /* first key */
            while (lua_next(L, -2)) {
                empty = false;
                if (lua_type(L, -2) != LUA_TNUMBER) {
                    dictionary = true;
                    lua_pop(L, 2); // pop key and value off the stack
                    break;
                }
                else {
                    lua_pop(L, 1);
                }
            }

            if (empty)
                dictionary = true;

            if (dictionary)
                yajl_gen_map_open(gen);
            else
                yajl_gen_array_open(gen);

            lua_pushnil(L);  /* first key */
            while (lua_next(L, -2)) {
                if (dictionary) {
                    size_t len;
                    const char *str;
                    if (lua_type(L, -2) == LUA_TNUMBER) {
                        lua_pushvalue(L, -2); // copy of the number
                        str = lua_tolstring(L, -1, &len); // converts value on stack to a string
                        lua_pop(L, 1); // pop off copy
                    } else {
                        str = lua_tolstring(L, -2, &len);
                    }
                    stat = yajl_gen_string(gen, (const unsigned char*)str, (unsigned int)len);
                }
                generate_value(gen, L);
                lua_pop(L, 1); // Pop off the value
            }

            if (dictionary)
                yajl_gen_map_close(gen);
            else
                yajl_gen_array_close(gen);

            lua_pop(L, 1); // Pop the table reference off
            break;
        }

        case LUA_TFUNCTION:
        case LUA_TUSERDATA:
        case LUA_TTHREAD:
        case LUA_TLIGHTUSERDATA:
        default:
            stat = yajl_gen_null(gen);
            break;
    }
}

static int generate(lua_State *L) {
    const unsigned char * buf;
    unsigned int len;
    yajl_gen_config conf = { .beautify = 0, .indentString = "  " };
    gen = yajl_gen_alloc(&conf, NULL);

    generate_value(gen, L);

    yajl_gen_get_buf(gen, &buf, &len);
    lua_pushlstring(L, (const char *)buf, len);

    yajl_gen_clear(gen);
    yajl_gen_free(gen);
    return 1;
}