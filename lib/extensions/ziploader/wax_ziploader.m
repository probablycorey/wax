//
//  wax_ziploader.m
//
//  Created by Jeremy Collins on 04/5/10.
//  Copyright 2010 Jeremy Collins. All rights reserved.
//

#import "wax_ziploader.h"

#import "wax_instance.h"
#import "wax_helpers.h"

#import "lua.h"
#import "lauxlib.h"

#import "unzip.h"

#ifndef WAX_DATA_DIR
#define WAX_DATA_DIR "data/"
#endif

#define LUA_VFS_FILE LUA_ROOT WAX_DATA_DIR "scripts/init.lar"

typedef struct LoadZF {
    unzFile *f;
    char buff[LUAL_BUFFERSIZE];
} LoadZF;

static const char *getZF (lua_State *L, void *ud, size_t *size) {
    LoadZF *zf = (LoadZF *)ud;
    if(unzeof(zf->f)) return NULL;
    *size = unzReadCurrentFile(zf->f, zf->buff, sizeof(zf->buff));
    return (*size > 0) ? zf->buff : NULL;
}

static const char *pushnexttemplate (lua_State *L, const char *path) {
    const char *l;
    while (*path == *LUA_PATHSEP) path++;  /* skip separators */
    if (*path == '\0') return NULL;  /* no more templates */
    l = strchr(path, *LUA_PATHSEP);  /* find next separator */
    if (l == NULL) l = path + strlen(path);
    lua_pushlstring(L, path, l - path);  /* template */
    return l;
}

static const char *findfile (lua_State *L, const char *name,
                             const char *pname,
                             unzFile *zipFile) {
    const char *path;
    name = luaL_gsub(L, name, ".", LUA_DIRSEP);
    //lua_getfield(L, LUA_ENVIRONINDEX, pname);
    lua_getglobal(L, "package");
    lua_getfield(L, -1, pname);
    path = lua_tostring(L, -1);
    if (path == NULL)
        luaL_error(L, LUA_QL("package.%s") " must be a string", pname);
    lua_pushliteral(L, "");  /* error accumulator */
    while ((path = pushnexttemplate(L, path)) != NULL) {
        const char *full;
        const char *filename;
        full = luaL_gsub(L, lua_tostring(L, -1), LUA_PATH_MARK, name);
        filename = luaL_gsub(L, full, "./", "");
        lua_remove(L, -2);  /* remove path template */
        if (unzLocateFile(zipFile, filename, 0) == UNZ_OK) {
            return filename;
        }
        lua_pushfstring(L, "\n\tno file in zip" LUA_QS, filename);
        lua_remove(L, -2);  /* remove file name */
        lua_concat(L, 2);  /* add entry to possible error message */
    }
    return NULL;  /* not found */
}

static int loader_Zip(lua_State *L) {
    const char *name = luaL_checkstring(L, 1);
    int status;
    LoadZF zf;
    int fnameindex = lua_gettop(L) + 1;
    
    unzFile *zip = unzOpen64("resources.dat");
    if(zip != NULL) {
        unzGoToFirstFile(zip);

        const char *filename = findfile(L, name, "path", zip);
        if(filename != NULL) {
            zf.f = zip;
            if(unzOpenCurrentFile(zip) == UNZ_OK) {
                status = lua_load(L, getZF, &zf, lua_tostring(L, -1));
            }
        }
        lua_remove(L, fnameindex);
        unzClose(zip);
    } else {
        // TODO: error
    }
    
    return 1;
}

int luaopen_wax_ziploader(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    lua_getglobal(L, "package");
    lua_getfield(L, -1, "loaders");
    lua_pushcfunction(L, loader_Zip);
    lua_rawseti(L, -2, 5);
    
    END_STACK_MODIFY(L, 0)
    
    return 1;
}
