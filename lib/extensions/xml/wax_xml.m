#import "wax_xml.h"

#import "wax_helpers.h"

#import "lua.h"
#import "lauxlib.h"

#import <stdio.h>
#import <libxml/parser.h>
#import <libxml/tree.h>


static void createTable(lua_State *L, xmlNode *node, char *textLabel, char *attrsLabel);
static int parse(lua_State *L);

static const struct luaL_Reg metaFunctions[] = {
    {NULL, NULL}
};

static const struct luaL_Reg functions[] = {
    {"parse", parse},
//    {"generate", generate},
    {NULL, NULL}
};

int luaopen_wax_xml(lua_State *L) {    
    luaL_newmetatable(L, XML_METATABLE_NAME);
    luaL_register(L, NULL, metaFunctions);
    luaL_register(L, XML_METATABLE_NAME, functions);    
    
    return 1;
}

static char *appendNamespaceToName(const char *name, xmlNs *ns) {
    char *prefixElementName = nil;
    size_t prefixElementNameSize = 0;
    if (ns && ns->prefix) {
        prefixElementNameSize = strlen((const char *)name) + 1; // 1 is added because of the namespace colon :
        prefixElementName = alloca(prefixElementNameSize + 1);
        memset(prefixElementName, 0, prefixElementNameSize + 1);
        strcat(prefixElementName, (const char *)ns->prefix);
        strcat(prefixElementName, ":");
    }
    
    
    size_t elementNameSize = prefixElementNameSize + strlen(name);
    char *elementName = malloc(elementNameSize + 1); // You got to free this later dude!
    memset(elementName, 0, elementNameSize + 1);
    if (prefixElementName) strcat(elementName, prefixElementName);
    strcat(elementName, name);
    
    return elementName;
}

static void createTable(lua_State *L, xmlNode *node, char *textLabel, char *attrsLabel) {
    for (; node; node = node->next) {
        switch (node->type) {
            case XML_ELEMENT_NODE: {
                
                // Combined the namespace with the node name
                char *elementName = appendNamespaceToName((const char *)node->name, node->ns);
                                                
                lua_newtable(L);
                
                // Push attribute table
                lua_pushstring(L, attrsLabel);
                lua_newtable(L);
                
                // Attributes ?
                xmlAttrPtr attribute = node->properties;
                for(; attribute; attribute = attribute->next) {
                    xmlChar* attributeValue = xmlNodeListGetString(node->doc, attribute->children, YES);
                    char *attributeName = appendNamespaceToName((const char *)attribute->name, attribute->ns);
                    lua_pushstring(L, (const char *)attributeValue);                    
                    lua_setfield(L, -2, attributeName);
                    free(attributeName);
                    xmlFree(attributeValue);
                }
                                
                // Set attribute table
                lua_rawset(L, -3);
                
                createTable(L, node->children, textLabel, attrsLabel);
                
                // If the element name already exists in the table, make it an array
                lua_getfield(L, -2, elementName); // get current value
                
                if (lua_isnil(L, -1)) { // not on stack yet, everything is cool
                    lua_pop(L, 1); // pop nil off
                    lua_setfield(L, -2, elementName);
                }
                else {
                    lua_getfield(L, -1, attrsLabel); // is the current occupant a node or an array?
                    BOOL existsAsArray = lua_isnil(L, -1);
                    lua_pop(L, 1); // pop off nil, or the attr table.
                    
                    if (!existsAsArray) {
                        lua_newtable(L);
                        lua_insert(L, -2); // move the former node on top of the new array
                        lua_rawseti(L, -2, 1); // add it to the new array
                        
                        lua_pushvalue(L, -1); // the new table
                        lua_setfield(L, -4, elementName); // add the new table to the parent array
                    }
                    
                    lua_insert(L, -2); // move the table above the new node
                    lua_rawseti(L, -2, lua_objlen(L, -2) + 1); // ad the new node
                    lua_pop(L, 1); // remove the table array
                }
                
                free(elementName);
                
                break;
            }
            case XML_TEXT_NODE:
                if (xmlIsBlankNode(node)) continue;
                
                lua_pushstring(L, textLabel);
                lua_pushstring(L, (const char *)node->content);
                lua_rawset(L, -3);
                
                break;                
            default:
                // I have no idea what these things are... XML is for weirdos
                luaL_error(L, "UNKNOWN NODE TYPE %d", node->type);
                break;
        }
    }
}

static int parse(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    xmlDocPtr doc;
    
    const char *xml = luaL_checkstring(L, 1);
    size_t length = lua_objlen(L, 1);
    
    char *textLabel = "text";
    char *attrsLabel = "attrs";
    
    if (lua_istable(L, 2)) {
        // check for text label
        lua_getfield(L, 2, "text");
        if (!lua_isnil(L, -1)) {
            textLabel = (char *)luaL_checkstring(L, -1);
        }
        lua_pop(L, 1); // pop off the custom text label, or nil
        
        // check for attrs label
        lua_getfield(L, 2, "attrs");
        if (!lua_isnil(L, -1)) {
            attrsLabel = (char *)luaL_checkstring(L, -1);
        }
        lua_pop(L, 1); // pop off the custom text label, or nil
        lua_pop(L, 1); // pop the custom label table off the stack (just making room!)
    }
    
    lua_pop(L, 1); // pop the xml off the stack (just making room!)
    
    doc = xmlReadMemory(xml, length, "noname.xml", NULL, 0);
    if (doc != NULL) {
        xmlNode *root_element = xmlDocGetRootElement(doc);
        
        lua_newtable(L); // creates table to return
        createTable(L, root_element, textLabel, attrsLabel);
    } 
    else {
        luaL_error(L, "Unable open for parsing xml");
    }
    
    xmlFreeDoc(doc);
    
    END_STACK_MODIFY(L, 1);
    
    return 1;
}