//
//  wax_sqlite_operation.m
//  SQLite
//
//  Created by Corey Johnson on 10/22/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "wax_sqlite_operation.h"
#import "wax_sqlite.h"

#import <sqlite3.h>
#import "lua.h"
#import "lauxlib.h"

#import "wax_helpers.h"

static void sqlite_push_column_value(sqlite3_stmt *statement, int columnIndex);

@implementation SQLiteOperation

+ (NSOperationQueue *)operationQueue {
    static NSOperationQueue *operationQueue;
    if (!operationQueue) {
        operationQueue = [[NSOperationQueue alloc] init];
        [operationQueue setMaxConcurrentOperationCount:1];
    }
    
    return operationQueue;
}

// SQLite calls use their own lua state to build up the response (because wax can't currently handle lua threads)
// I want to just create a subthread, but can't because of the way I hacked the Lua GC
+ (lua_State *)operationLuaState {
    static lua_State *L;
    if (!L) L = lua_open();

    return L;
}

- (void)dealloc {
    [_sqlString release];
    [super dealloc];
}

- (id)initWithLuaState:(lua_State *)L db:(sqlite3 *)db sql:(const char *)sqlString {
    self = [super init];
    _mainthread = L;
    _db = db;
    _sqlString = [[NSString alloc] initWithUTF8String:sqlString];
    
    return self;
}

- (void)main {
    if ([self isCancelled]) return;
    
    lua_State *L = [[self class] operationLuaState];
    lua_settop(L, 0); // Clear the stack!
    
    sqlite3_stmt *statement;
    
    BOOL exit = NO;
    
    wax_log(LOG_DEBUG, [_sqlString stringByReplacingOccurrencesOfString:@"%" withString:@"%%"]);
    
    int prepareResult = sqlite3_prepare_v2(_db, [_sqlString UTF8String], -1, &statement, nil);
    if (prepareResult == SQLITE_OK) {
        lua_newtable(L); // New result set
        
        while (sqlite3_step(statement) == SQLITE_ROW && !exit) {
            if ([self isCancelled]) {
                exit = YES;
                continue;
            }
            
            lua_newtable(L); // New Row
            
            for (int i = 0; i < sqlite3_column_count(statement); i++) {
                lua_pushstring(L, sqlite3_column_name(statement, i)); // Push the column name                
                exit = ![self pushColumnValueForStatement:statement index:i];                
                lua_rawset(L, -3); // Add the column
            }
            
            lua_rawseti(L, -2, lua_objlen(L, -2) + 1); // Add the row
        }
        
        int finalizeResult = sqlite3_finalize(statement);
        if (finalizeResult != SQLITE_OK) {
            NSString *string = [NSString stringWithFormat:@"Failed to finalize SQL statement '%@'. Error #%d.", _sqlString, finalizeResult];
            lua_settop(L, 0); // Clear the stack!
            [self performSelectorOnMainThread:@selector(error:) withObject:string waitUntilDone:NO];
            return;
        }
        
        if ([self isCancelled]) return;
        
        [self performSelectorOnMainThread:@selector(operationComplete) withObject:nil waitUntilDone:YES];
        
    }
    else {
        sqlite3_finalize(statement);
        NSString *string = [NSString stringWithFormat:@"Failed to execute SQL '%@'. Error #%d.", _sqlString, prepareResult];    
        [self performSelectorOnMainThread:@selector(error:) withObject:string waitUntilDone:NO];
        return;
    }
}

- (bool)pushColumnValueForStatement:(sqlite3_stmt *)statement index:(int)columnIndex {
    lua_State *L = [[self class] operationLuaState];
    int columnType = sqlite3_column_type(statement, columnIndex);                
    sqlite3_value *columnValue =  sqlite3_column_value(statement, columnIndex);
    
    switch(columnType) {
        case SQLITE_NULL:
            lua_pushnil(L);
            break;
        case SQLITE_INTEGER:
            lua_pushnumber(L, sqlite3_value_int(columnValue));
            break;
        case SQLITE_FLOAT:
            lua_pushnumber(L, sqlite3_value_double(columnValue));
            break;            
        case SQLITE3_TEXT:
            lua_pushstring(L, (const char *)sqlite3_value_text(columnValue));
            break;
        case SQLITE_BLOB:
            lua_pushlstring(L, sqlite3_value_blob(columnValue), sqlite3_value_bytes(columnValue));
            break;    
        default: {
            lua_pushnil(L);
            NSString *string = [NSString stringWithFormat:@"Unknown SQLite column type %d for SQL string '%@'", columnValue, _sqlString];    
            [self performSelectorOnMainThread:@selector(error:) withObject:string waitUntilDone:NO];
            return NO;
        }
    }    
    
    return YES;
}

- (void)operationComplete {
    lua_State *L = _mainthread;
    lua_State *operationLuaState = [[self class] operationLuaState];
    
    BEGIN_STACK_MODIFY(L)
    
    // If a callback exists, call it!
    wax_instance_pushUserdata(L, self);
    lua_getfenv(L, -1); // get env
    lua_getfield(L, -1, WAX_SQLITE_CALLBACK_NAME);
        
    bool hasCallback = !lua_isnil(L, -1);

    wax_copyObject(operationLuaState, L, 1);
    lua_settop(operationLuaState, 0);
    
    if (![self isCancelled] && hasCallback && wax_pcall(L, 1, 0)) {
        const char* error_string = lua_tostring(L, -1);
        printf("Problem calling Lua function callback for SQLite.\n%s", error_string);

    }
    
    END_STACK_MODIFY(L, hasCallback ? 0 : 1);
}

- (void)error:(NSString *)string {
    luaL_error(_mainthread, [string UTF8String]);
}

@end