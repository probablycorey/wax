//
//  wax_sqlite.m
//  SQLite
//
//  Created by Corey Johnson on 10/21/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <sqlite3.h>

#import "lua.h"
#import "lauxlib.h"

#import "wax_sqlite.h"
#import "wax_sqlite_operation.h"
#import "wax_instance.h"

static int openDB(lua_State *L);
static int closeDB(lua_State *L);
static int execute(lua_State *L);

static int push(lua_State *L);

static const struct luaL_Reg metaFunctions[] = {
    {NULL, NULL}
};

static const struct luaL_Reg functions[] = {
    {"open", openDB},
    {"close", closeDB},    
    {"execute", execute},    
    {NULL, NULL}
};

int luaopen_wax_sqlite(lua_State *L) {    
    luaL_newmetatable(L, WAX_SQLITE_METATABLE_NAME);        
    luaL_register(L, NULL, metaFunctions);
    luaL_register(L, WAX_SQLITE_METATABLE_NAME, functions);    
    
    return 1;
}

// wax.sqlite.open() => returns db object
static int openDB(lua_State *L) {
    const char *databasePath = luaL_checkstring(L, 1);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:databasePath]]) {
        luaL_error(L, "No database found at path '%s'", databasePath);
    }
    
    size_t nbytes = sizeof(wax_sqlite_userdata);
    wax_sqlite_userdata *dbUserdata = (wax_sqlite_userdata *)lua_newuserdata(L, nbytes);    
    dbUserdata->db = nil;
    
    // Set the metatable for this object
    luaL_getmetatable(L, WAX_SQLITE_METATABLE_NAME);
    lua_setmetatable(L, -2);
        
    if (!sqlite3_open(databasePath, &dbUserdata->db) == SQLITE_OK) {
        sqlite3_close(dbUserdata->db); // Even though the open failed, call close to properly clean up resources.        
        luaL_error(L, "Failed to open database at '%s' because '%s'.", databasePath, sqlite3_errmsg(dbUserdata->db));
    }
        
    return 1;
}

// wax.sqlite.close(db) # Closes the db!
static int closeDB(lua_State *L) {
    wax_sqlite_userdata *dbUserdata = luaL_checkudata(L, 1, WAX_SQLITE_METATABLE_NAME);
    
    sqlite3_close(dbUserdata->db);
    dbUserdata->db = nil;
    
    return 0;
}

// wax.sqlite.execute(db, sql, callback) => returns wax_sqlite_operation
//   callback = function(results) # No callback? Then treat as syncronous
int execute(lua_State *L) {
    wax_sqlite_userdata *dbUserdata = luaL_checkudata(L, 1, WAX_SQLITE_METATABLE_NAME);
    const char *sqlString = luaL_checkstring(L, 2);

    SQLiteOperation *operation = [[SQLiteOperation alloc] initWithLuaState:L db:dbUserdata->db sql:sqlString];
    wax_instance_create(L, operation, NO);

    bool hasCalback = lua_isfunction(L, 3);
    
    // if there is a callback, do this in an NSOperation
    if (hasCalback) {        
        lua_getfenv(L, -1); // get operations env
        lua_pushstring(L, WAX_SQLITE_CALLBACK_NAME);
        lua_pushvalue(L, 3); // Push the function callback
        lua_rawset(L, -3); // Associate the operation with the callback
        lua_pop(L, 1); // pop the env off
    }
    else {
        lua_pop(L, 1); // Pop the nil off!
    }
    
    NSOperationQueue *queue = [SQLiteOperation operationQueue];
    [queue addOperation:operation];
    [operation release];    
    
    
    if (!hasCalback) {
        NSRunLoop* runLoop = [NSRunLoop currentRunLoop];        
        while (![operation isFinished]) {
            [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
        }
        
        // Results should be on top!                
    }
    
    return 1;
}