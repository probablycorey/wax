#import "wax_xml.h"

#import "wax_helpers.h"

#import "lua.h"
#import "lauxlib.h"

#import <stdio.h>
//if you want to use xml and this line compiled error, link binary with libxml2 and add head file search path with '${SDK_DIR}/usr/include/libxml2'
#import <libxml/parser.h>
#import <libxml/tree.h>

#define XML_DEFAULT_TEXT_LABEL "text"
#define XML_DEFAULT_ATTRS_LABEL "attrs"
#define XML_MAX_LABEL_LENGTH 1000

static void createTable(lua_State *L, xmlNode *node, char *textLabel, char *attrsLabel);
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

int luaopen_wax_xml(lua_State *L) {
    BEGIN_STACK_MODIFY(L)

    luaL_newmetatable(L, WAX_XML_METATABLE_NAME);
    luaL_register(L, NULL, metaFunctions);
    luaL_register(L, WAX_XML_METATABLE_NAME, functions);

    END_STACK_MODIFY(L, 0)

    return 0;
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
            case XML_COMMENT_NODE: // do nothing if it's a comment
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

    int xmlLength = lua_objlen(L, 1) + 1;
    char *xml = alloca(xmlLength);
    strncpy(xml, luaL_checkstring(L, 1), xmlLength);

    char textLabel[XML_MAX_LABEL_LENGTH] = XML_DEFAULT_TEXT_LABEL;
    char attrsLabel[XML_MAX_LABEL_LENGTH] = XML_DEFAULT_ATTRS_LABEL;

    if (lua_istable(L, 2)) {
        // check for text label
        lua_getfield(L, 2, XML_DEFAULT_TEXT_LABEL);
        if (!lua_isnil(L, -1)) {
            int length = lua_objlen(L, -1);
            memset(textLabel, 0, XML_MAX_LABEL_LENGTH);
            strncpy(textLabel, luaL_checkstring(L, -1), MIN(length, XML_MAX_LABEL_LENGTH - 1));
        }
        lua_pop(L, 1); // pop off the custom text label, or nil

        // check for attrs label
        lua_getfield(L, 2, XML_DEFAULT_ATTRS_LABEL);
        if (!lua_isnil(L, -1)) {
            int length = lua_objlen(L, -1);
            memset(attrsLabel, 0, XML_MAX_LABEL_LENGTH);
            strncpy(attrsLabel, luaL_checkstring(L, -1), MIN(length, XML_MAX_LABEL_LENGTH - 1));
        }
        lua_pop(L, 1); // pop off the custom text label, or nil

        lua_pop(L, 1); // pop the custom label table off the stack (just making room!)
    }

    lua_pop(L, 1); // pop the xml off the stack (just making room!)

    doc = xmlReadMemory(xml, xmlLength, "noname.xml", NULL, 0);
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

static void createAttributes(lua_State *L, xmlNodePtr node) {
    lua_pushnil(L);
    while (lua_next(L, -2)) {
        xmlChar *name = BAD_CAST luaL_checkstring(L, -2);
        xmlChar *value = BAD_CAST luaL_checkstring(L, -1);

        xmlNewProp(node, name, value);

        lua_pop(L, 1); // pop the value
    }
}

static BOOL isNumericIndexedArray(lua_State *L, int idx) {
    BOOL isArray = NO;
    if (lua_istable(L, idx)) {
        lua_pushnil(L);
        if (lua_next(L, idx-1)) {
            isArray = (lua_isnumber(L, -2) && lua_tointeger(L, -2) == 1);
            lua_pop(L, 2);
        }
    }
    return isArray;
}

static void createXML(lua_State *L, xmlDocPtr doc, xmlNodePtr node, char *textLabel, char *attrsLabel);

static void createElement(lua_State *L, xmlDocPtr doc, xmlNodePtr node, const char *name, char *textLabel, char *attrsLabel) {
    xmlNodePtr childNode = xmlNewNode(NULL, BAD_CAST name);
    xmlAddChild(node, childNode);
    createXML(L, doc, childNode, textLabel, attrsLabel);
    
    if (!node) // Root node.
        xmlDocSetRootElement(doc, childNode);
}

static void createXML(lua_State *L, xmlDocPtr doc, xmlNodePtr node, char *textLabel, char *attrsLabel) {
    if (lua_isstring(L, -1)) { // Could just be a string. If so, just set the text of the node
        xmlNodePtr textNode = xmlNewText(BAD_CAST lua_tostring(L, -1));
        xmlAddChild(node, textNode);
        return;
    }

    lua_pushnil(L);
    while (lua_next(L, -2)) {
        const char *name = luaL_checkstring(L, -2);

        if (strcmp(name, textLabel) == 0) {
            xmlNodePtr textNode = xmlNewText(BAD_CAST lua_tostring(L, -1));
            xmlAddChild(node, textNode);
        }
        else if (strcmp(name, attrsLabel) == 0) {
            createAttributes(L, node);
        }
        else {
            if (isNumericIndexedArray(L, -1)) {
                lua_pushnil(L);
                while (lua_next(L, -2)) {
                    createElement(L, doc, node, name, textLabel, attrsLabel); 
                    if (!node) { // Ignore duplicate root nodes
                        lua_pop(L, 2);
                        break;
                    }
                    lua_pop(L, 1);
                }
            }
            else {
                createElement(L, doc, node, name, textLabel, attrsLabel);
            }
            if (!node) { // Root node. Ignore other root nodes
                lua_pop(L, 2); // remove the value and the key
                break;
            }
        }

        lua_pop(L, 1); // remove the value
    }
}

static int generate(lua_State *L) {
    BEGIN_STACK_MODIFY(L);

    xmlDocPtr doc = xmlNewDoc(BAD_CAST "1.0");

    char textLabel[XML_MAX_LABEL_LENGTH] = XML_DEFAULT_TEXT_LABEL;
    char attrsLabel[XML_MAX_LABEL_LENGTH] = XML_DEFAULT_ATTRS_LABEL;

    if (lua_istable(L, 2)) {
        // check for text label
        lua_getfield(L, 2, XML_DEFAULT_TEXT_LABEL);
        if (!lua_isnil(L, -1)) {
            int length = lua_objlen(L, -1);
            memset(textLabel, 0, XML_MAX_LABEL_LENGTH);
            strncpy(textLabel, luaL_checkstring(L, -1), MIN(length, XML_MAX_LABEL_LENGTH - 1));
        }
        lua_pop(L, 1); // pop off the custom text label, or nil

        // check for attrs label
        lua_getfield(L, 2, XML_DEFAULT_ATTRS_LABEL);
        if (!lua_isnil(L, -1)) {
            int length = lua_objlen(L, -1);
            memset(attrsLabel, 0, XML_MAX_LABEL_LENGTH);
            strncpy(attrsLabel, luaL_checkstring(L, -1), MIN(length, XML_MAX_LABEL_LENGTH - 1));
        }
        lua_pop(L, 1); // pop off the custom text label, or nil

        lua_pop(L, 1); // pop the custom label table off the stack (just making room!)
    }

    createXML(L, doc, nil, textLabel, attrsLabel);

    // Dumping string to lua
    xmlChar *outputBuff;
    int outputLength;
    xmlDocDumpMemoryEnc(doc, &outputBuff, &outputLength, "UTF-8");

    lua_pushlstring(L, (char *)outputBuff, outputLength);

    xmlFreeDoc(doc);

    END_STACK_MODIFY(L, 1);

    return 1;
}

void wax_xml_parseString(lua_State *L, const char *xml) {
    lua_State *parseL = lua_newthread(L);
    lua_pushstring(parseL, xml);
    parse(parseL);
    lua_xmove(parseL, L, 1); // move the result to the current state
    lua_remove(L, -2); // remove the parsing thread
}
