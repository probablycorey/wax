#ifndef wax_xml
#define wax_xml_h

#import "lua.h"

#define XML_METATABLE_NAME "wax.xml"

int luaopen_wax_xml(lua_State *L);
void wax_xml_parseString(lua_State *L, const char *input);

#endif