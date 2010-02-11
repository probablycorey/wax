//
//  wax_sqlite_operation.h
//  SQLite
//
//  Created by Corey Johnson on 10/22/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "lua.h"


@interface SQLiteOperation : NSOperation {
    sqlite3 *_db;
    lua_State *_mainthread;
    NSString *_sqlString;
}

+ (NSOperationQueue *)operationQueue;

- (id)initWithLuaState:(lua_State *)L db:(sqlite3 *)db sql:(const char *)sqlString;
- (bool)pushColumnValueForStatement:(sqlite3_stmt *)statement index:(int)columnIndex;
- (void)error:(NSString *)string;

@end
