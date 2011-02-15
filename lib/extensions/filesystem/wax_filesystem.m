//
//  Created by Corey Johnson on 10/5/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "wax_filesystem.h"

#import "wax_instance.h"
#import "wax_helpers.h"

#import "lua.h"
#import "lauxlib.h"

#define TABLE_NAME "wax.filesystem"

// wax.filesystem.search(searchPath, [pattern]) => table
//     searchPath: string # where to start search (must be a directory)
//     pattern: string # only include files that match the pattern
static int search(lua_State *L) {
    NSString *searchPath = [NSString stringWithUTF8String:luaL_checkstring(L, 1)];
    const char *searchPattern = nil;

    if (lua_gettop(L) > 1) {
        searchPattern = luaL_checkstring(L, 2);
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    
    NSArray *filenames = [fm subpathsOfDirectoryAtPath:searchPath error:&error];
    NSMutableArray *paths = [NSMutableArray array];
    
    for (NSString *filename in filenames) {        
        [paths addObject:[searchPath stringByAppendingPathComponent:filename]];
    }
    
    if (error) {
        luaL_error(L, "Could not read directory path at '%s'. Error: %s", [searchPath UTF8String], [[error localizedDescription] UTF8String]);
    }
    
    if (searchPattern) { 
        NSMutableArray *matchedPaths = [NSMutableArray array];
        
        lua_getglobal(L, "string");
        
        for (NSString *path in paths) {
            lua_getfield(L, -1, "match");
            lua_pushstring(L, [path UTF8String]);
            lua_pushstring(L, searchPattern);            
            lua_call(L, 2, 1);
            
            if (!lua_isnil(L, -1)) {
                [matchedPaths addObject:path];
            }
            lua_pop(L, 1);            
        }
        
        lua_pop(L, 1); // pop string table off the stack
        
        paths = matchedPaths;
    }
    
    wax_fromObjc(L, "@", &paths);
    
    return 1;
}


// wax.filesystem.contents(path) => NSData | table
//     path: string #if filepath is a directory, the result will be a table. A file will return NSData
static int contents(lua_State *L) {
    NSString *path = [NSString stringWithUTF8String:luaL_checkstring(L, 1)];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL directory;
    BOOL exists = [fm fileExistsAtPath:path isDirectory:&directory];

    if (!exists) {
        lua_pushnil(L);
    }    
    else if (directory) {
        NSError *error = nil;
        NSArray *contents = [fm contentsOfDirectoryAtPath:path error:&error];   
        
        if (error) {
            wax_log(LOG_DEBUG, @"Could not get contents for directory at '%@'\n%@", path, [error localizedDescription]);
        }
        
        wax_fromObjc(L, "@", &contents);
    }
    else {
        NSData *contents = [fm contentsAtPath:path];
        wax_fromObjc(L, "@", &contents);
    }
    
    return 1;
}

static int basename(lua_State *L) {
    const char *path = luaL_checkstring(L, 1);
    char *basename = strrchr(path, '/');
    lua_pushstring(L, basename ? basename + 1 : path);
    return 1;    
}

static int isDir(lua_State *L) {
    NSString *path = [NSString stringWithUTF8String:luaL_checkstring(L, 1)];

    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL directory;
    BOOL exists = [fm fileExistsAtPath:path isDirectory:&directory];
    
    lua_pushboolean(L, exists && directory);
    
    return 1;    
}

static int isFile(lua_State *L) {
    NSString *path = [NSString stringWithUTF8String:luaL_checkstring(L, 1)];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL directory;
    BOOL exists = [fm fileExistsAtPath:path isDirectory:&directory];
    
    lua_pushboolean(L, exists && !directory);
    
    return 1;    
}

static int exists(lua_State *L) {
    NSString *path = [NSString stringWithUTF8String:luaL_checkstring(L, 1)];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exists = [fm fileExistsAtPath:path isDirectory:nil];
    
    lua_pushboolean(L, exists);
    
    return 1;    
}

// wax.filesystem.attributes(path) => table
//     path: string 
// 
// # contains some simple mappings to some attributes (just look at the code to find out what is mapped)
static int attributes(lua_State *L) {
    NSString *path = [NSString stringWithUTF8String:luaL_checkstring(L, 1)];
    
    NSFileManager *fm = [NSFileManager defaultManager];    
    NSError *error = nil;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[fm attributesOfItemAtPath:path error:&error]];
    
    if (error) {
        wax_log(LOG_DEBUG, @"No attributes found for '%@'\n%@", path, [error localizedDescription]);
        lua_pushnil(L);
        return  1;
    }

    // Make some helper accessors
    NSTimeInterval modifiedAt = [[attributes objectForKey:NSFileModificationDate] timeIntervalSince1970];
    [attributes setObject:[NSNumber numberWithDouble:modifiedAt] forKey:@"modifiedAt"];

    NSTimeInterval createdAt = [[attributes objectForKey:NSFileCreationDate] timeIntervalSince1970];
    [attributes setObject:[NSNumber numberWithDouble:createdAt] forKey:@"createdAt"];

    NSNumber *fileSize = [attributes objectForKey:NSFileSize];
    [attributes setObject:fileSize forKey:@"size"];
    
    wax_fromObjc(L, "@", &attributes);
    
    return 1;
}

// wax.filesystem.createFile(path, content) => boolean
//     path: string # filepath
//     content: NSData | string # contents of file
static int createFile(lua_State *L) {
    NSString *path = [NSString stringWithUTF8String:luaL_checkstring(L, 1)];
    NSData *data = nil;

    if (lua_isstring(L, 2)) {
        size_t contentLength;
        const char *content = luaL_checklstring(L, 2, &contentLength);  
        data = [NSData dataWithBytesNoCopy:(char *)content length:contentLength freeWhenDone:NO];
    }
    else { // Assume it is an NSData object
        wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 2, WAX_INSTANCE_METATABLE_NAME);
        data = instanceUserdata->instance;
    }
        
    NSError *error = nil;
    BOOL success = [data writeToFile:path atomically:NO];
    
    if (!success) {
        wax_log(LOG_DEBUG, @"Could not create file at '%@'\n%@", path, [error localizedDescription]);
    }
    
    lua_pushboolean(L, success);
    
    return 1;
}

// wax.filesystem.createDir(path, createParentDirs) => boolean
//     path: string # dir path
//     createParentDirs: boolean # (optional) should intermediate parent dirs be created÷
static int createDir(lua_State *L) {
    NSString *path = [NSString stringWithUTF8String:luaL_checkstring(L, 1)];
    BOOL createParentDirs = NO;
    if (lua_gettop(L) > 1) createParentDirs = lua_toboolean(L, 2);
    
    NSError *error = nil;
    NSFileManager *fm = [NSFileManager defaultManager];    
    BOOL success = [fm createDirectoryAtPath:path withIntermediateDirectories:createParentDirs attributes:nil error:&error];
    
    if (!success) {
        wax_log(LOG_DEBUG, @"Could not create dir at '%@'\n%@", path, [error localizedDescription]);
    }
    
    lua_pushboolean(L, success);
    
    return 1;
}


// wax.filesystem.delete(path, [force]) => boolean
//     path: string # deletes the path or directory (EVEN IF DIRECTORY HAS CONTENTS)
static int delete(lua_State *L) {
    NSString *path = [NSString stringWithUTF8String:luaL_checkstring(L, 1)];
	
	BOOL success = YES;
    NSFileManager *fm = [NSFileManager defaultManager];    
	if ([fm fileExistsAtPath:path]) {	
		NSError *error = nil;
		success = [fm removeItemAtPath:path error:&error];

		if (!success) {
			wax_log(LOG_DEBUG, @"Could not delete file at '%@'\n%@", path, [error localizedDescription]);
		}
	}
	else {
		wax_log(LOG_DEBUG, @"Trying to delete path that does not exist '%@'", path);
	}
	
	lua_pushboolean(L, success);
    
    return 1;
}

static const struct luaL_Reg functions[] = {
    {"search", search},
    {"contents", contents},    
    {"basename", basename},
    {"exists", exists},
    {"isDir", isDir},
    {"isFile", isFile},
    
    {"attributes", attributes},
    
    {"createDir", createDir},   
    {"createFile", createFile},    
    {"delete", delete},

    {NULL, NULL}
};

int luaopen_wax_filesystem(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    luaL_register(L, TABLE_NAME, functions);    
    
    END_STACK_MODIFY(L, 0)
    
    return 1;
}