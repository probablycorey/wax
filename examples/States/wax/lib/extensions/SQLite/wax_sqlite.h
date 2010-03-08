//
//  wax_sqlite.h
//  SQLite
//
//  Created by Corey Johnson on 10/21/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "lua.h"

#define WAX_SQLITE_METATABLE_NAME "wax.sqlite"
#define WAX_SQLITE_CALLBACK_NAME "sqlite-callback"

struct sqlite3;

typedef struct _wax_sqlite_userdata {
    sqlite3 *db;
    
} wax_sqlite_userdata;


int luaopen_wax_sqlite(lua_State *L);