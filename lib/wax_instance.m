/*
 *  wax_instance.c
 *  Lua
 *
 *  Created by ProbablyInteractive on 5/18/09.
 *  Copyright 2009 Probably Interactive. All rights reserved.
 *
 */

#import "wax_instance.h"
#import "wax_class.h"
#import "wax.h"
#import "wax_helpers.h"

#import "lauxlib.h"
#import "lobject.h"
#import "wax_config.h"
static int __index(lua_State *L);
static int __newindex(lua_State *L);
static int __gc(lua_State *L);
static int __tostring(lua_State *L);
static int __eq(lua_State *L);
static int __call(lua_State *L) ;

static int methods(lua_State *L);

static int methodClosure(lua_State *L);
static int superMethodClosure(lua_State *L);
static int customInitMethodClosure(lua_State *L);

static BOOL overrideMethod(lua_State *L, wax_instance_userdata *instanceUserdata);
static int pcallUserdata(lua_State *L, id self, SEL selector, va_list args);
static BOOL overrideMethodByInvocation(id klass, SEL selector, char *typeDescription, char *returnType) ;
static BOOL addMethodByInvocation(id klass, SEL selector, char * typeDescription) ;

//block call
extern int luaCallBlock(lua_State *L);


extern void wax_printStack(lua_State *L);
extern void wax_printStackAt(lua_State *L, int i);
extern void wax_printTable(lua_State *L, int t);
extern void wax_log(int flag, NSString *format, ...);
extern int wax_getStackTrace(lua_State *L);

static const struct luaL_Reg metaFunctions[] = {
    {"__index", __index},
    {"__newindex", __newindex},
    {"__gc", __gc},
    {"__tostring", __tostring},
    {"__eq", __eq},
    {"__call", __call},
    {NULL, NULL}
};

static const struct luaL_Reg functions[] = {
    {"methods", methods},
    {NULL, NULL}
};

int luaopen_wax_instance(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    luaL_newmetatable(L, WAX_INSTANCE_METATABLE_NAME);
    luaL_register(L, NULL, metaFunctions);
    luaL_register(L, WAX_INSTANCE_METATABLE_NAME, functions);
    
    END_STACK_MODIFY(L, 0)
    
    return 1;
}

#pragma mark Instance Utils
#pragma mark -------------------

// Creates userdata object for obj-c instance/class and pushes it onto the stack
wax_instance_userdata *wax_instance_create(lua_State *L, id instance, BOOL isClass) {
    BEGIN_STACK_MODIFY(L)
    
    // Does user data already exist?
    wax_instance_pushUserdata(L, instance);
   
    if (lua_isnil(L, -1)) {
//        wax_log(LOG_GC, @"Creating %@ for %@(%p)", isClass ? @"class" : @"instance", [instance class], instance);
        lua_pop(L, 1); // pop nil stack
    }
    else {
        wax_instance_userdata *data = lua_touserdata(L, -1);
        [wax_globalLock() unlock];//need unlock
//        wax_log(LOG_GC, @"Found existing userdata %@ for %@(%p -> %p)", isClass ? @"class" : @"instance", [instance class], instance, data);
        return  data;
    }
    
    size_t nbytes = sizeof(wax_instance_userdata);
    wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)lua_newuserdata(L, nbytes);
    instanceUserdata->instance = instance;
    instanceUserdata->isClass = isClass;
    instanceUserdata->isSuper = nil;
	instanceUserdata->actAsSuper = NO;
    
//    wax_log(LOG_GC, @"CreateUserdata %@ for %@(%p -> %p)", isClass ? @"class" : @"instance", [instance class], instance, instanceUserdata);
    if (!isClass) {//retain when not metaClass
//        wax_log(LOG_GC, @"Retaining %@ for %@(%p -> %p)", isClass ? @"class" : @"instance", [instance class], instance, instanceUserdata);
        [instanceUserdata->instance retain];
    }
    
    // set the metatable
    luaL_getmetatable(L, WAX_INSTANCE_METATABLE_NAME);
    lua_setmetatable(L, -2);

    // give it a nice clean environment
    lua_newtable(L);
    lua_setfenv(L, -2);
    
    wax_instance_pushUserdataTable(L);

    // register the userdata table in the metatable (so we can access it from obj-c)
    //wax_log(LOG_GC, @"Storing reference of %@ to userdata table %@(%p -> %p)", isClass ? @"class" : @"instance", [instance class], instance, instanceUserdata);        
    lua_pushlightuserdata(L, instanceUserdata->instance);
    lua_pushvalue(L, -3); // Push userdata
    lua_rawset(L, -3);//__wax_userdata[instanceUserdata->instance]=instanceUserdata
        
    lua_pop(L, 1); // Pop off userdata tabl6e

    
    wax_instance_pushStrongUserdataTable(L);//strong和weak table均增加对instanceUserdata的引用?
    lua_pushlightuserdata(L, instanceUserdata->instance);
    lua_pushvalue(L, -3); // Push userdata
    lua_rawset(L, -3);
    
    //wax_log(LOG_GC, @"Storing reference to strong userdata table %@(%p -> %p)", [instance class], instance, instanceUserdata);        
    
    lua_pop(L, 1); // Pop off strong userdata table
    
    END_STACK_MODIFY(L, 1)
    
    return instanceUserdata;
}

// Creates pseudo-super userdata object for obj-c instance and pushes it onto the stack
wax_instance_userdata *wax_instance_createSuper(lua_State *L, wax_instance_userdata *instanceUserdata) {
    BEGIN_STACK_MODIFY(L)
    
    size_t nbytes = sizeof(wax_instance_userdata);
    wax_instance_userdata *superInstanceUserdata = (wax_instance_userdata *)lua_newuserdata(L, nbytes);
    superInstanceUserdata->instance = instanceUserdata->instance;
    superInstanceUserdata->isClass = instanceUserdata->isClass;
	superInstanceUserdata->actAsSuper = YES;
	
	// isSuper not only stores whether the class is a super, but it also contains the value of the next superClass
	if (instanceUserdata->isSuper) {
		superInstanceUserdata->isSuper = [instanceUserdata->isSuper superclass];
	}
	else {
		superInstanceUserdata->isSuper = [instanceUserdata->instance superclass];
	}

    
    // set the metatable
    luaL_getmetatable(L, WAX_INSTANCE_METATABLE_NAME);
    lua_setmetatable(L, -2);
        
    wax_instance_pushUserdata(L, instanceUserdata->instance);
    if (lua_isnil(L, -1)) { // instance has no lua object, push empty env table (This shouldn't happen, tempted to remove it)
        lua_pop(L, 1); // Remove nil and superclass userdata
        lua_newtable(L); 
    }
    else {
        lua_getfenv(L, -1);
        lua_remove(L, -2); // Remove nil and superclass userdata
    }

	// Give it the instance's metatable
    lua_setfenv(L, -2);
    
    END_STACK_MODIFY(L, 1)
    
    return superInstanceUserdata;
}

// The userdata table holds weak references too all the instance userdata
// created. This is used to manage all instances of Objective-C objects created
// via Lua so we can release/gc them when both Lua and Objective-C are finished with
// them.
void wax_instance_pushUserdataTable(lua_State *L) {
    BEGIN_STACK_MODIFY(L)
    static const char* userdataTableName = "__wax_userdata";
    luaL_getmetatable(L, WAX_INSTANCE_METATABLE_NAME);
    lua_getfield(L, -1, userdataTableName);
    
    if (lua_isnil(L, -1)) { // Create new userdata table, add it to metatable
        lua_pop(L, 1); // Remove nil
        
        lua_pushstring(L, userdataTableName); // Table name
        lua_newtable(L);        
        lua_rawset(L, -3); // Add userdataTableName table to WAX_INSTANCE_METATABLE_NAME      
        lua_getfield(L, -1, userdataTableName);
        
        lua_pushvalue(L, -1);
        lua_setmetatable(L, -2); // userdataTable is it's own metatable
        
        lua_pushstring(L, "v");
        lua_setfield(L, -2, "__mode");  // Make weak table
    }
    
    END_STACK_MODIFY(L, 1)
}

// Holds strong references to userdata created by wax... if the retain count dips below
// 2, then we can remove it because we know obj-c doesn't care about it anymore
void wax_instance_pushStrongUserdataTable(lua_State *L) {
    BEGIN_STACK_MODIFY(L)
    static const char* userdataTableName = "__wax_strong_userdata";
    luaL_getmetatable(L, WAX_INSTANCE_METATABLE_NAME);
    lua_getfield(L, -1, userdataTableName);
    
    if (lua_isnil(L, -1)) { // Create new userdata table, add it to metatable
        lua_pop(L, 1); // Remove nil
        
        lua_pushstring(L, userdataTableName); // Table name
        lua_newtable(L);        
        lua_rawset(L, -3); // Add userdataTableName table to WAX_INSTANCE_METATABLE_NAME      
        lua_getfield(L, -1, userdataTableName);
    }
    
    END_STACK_MODIFY(L, 1)
}


// First look in the object's userdata for the function, then look in the object's class's userdata
BOOL wax_instance_pushFunction(lua_State *L, id self, SEL selector) {
    BEGIN_STACK_MODIFY(L)
    
    wax_instance_pushUserdata(L, self);
    if (lua_isnil(L, -1)) {
        // TODO:
        // quick and dirty solution to let obj-c call directly into lua
        // cause a obj-c leak, should we release it later?
        wax_instance_create(L, self, NO);
//        wax_instance_userdata *data = wax_instance_create(L, self, NO);
//        NSLog(@"data->waxRetain = YES instance=%@", data->instance);
    }
    
    lua_getfenv(L, -1);
    wax_pushMethodNameFromSelector(L, selector);
    lua_rawget(L, -2);
    
    BOOL result = YES;
    
    if (!lua_isfunction(L, -1)) { // function not found in userdata
        lua_pop(L, 3); // Remove userdata, env and non-function
        if ([self class] == self) { // This is a class, not an instance
            if(nil == self){//already root object
                result = NO;
            }else{
                result = wax_instance_pushFunction(L, [self superclass], selector); // Check to see if the super classes know about this function
            }
        }
        else {
            result = wax_instance_pushFunction(L, [self class], selector);
        }
    }
    
    END_STACK_MODIFY(L, 1)
    
    return result;
}

// Retrieves associated userdata for an object from the wax instance userdata table
void wax_instance_pushUserdata(lua_State *L, id object) {
    BEGIN_STACK_MODIFY(L);
    
    wax_instance_pushUserdataTable(L);
    lua_pushlightuserdata(L, object);
    lua_rawget(L, -2);
    lua_remove(L, -2); // remove userdataTable
    
    
    END_STACK_MODIFY(L, 1)
}

BOOL wax_instance_isWaxClass(id instance) {
     // If this is a wax class, or an instance of a wax class, it has the userdata ivar set
    return class_getInstanceVariable([instance class], WAX_CLASS_INSTANCE_USERDATA_IVAR_NAME) != nil;
}


#pragma mark Override Metatable Functions
#pragma mark ---------------------------------

static int __call(lua_State *L) {
    wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 1, WAX_INSTANCE_METATABLE_NAME);
    NSString *des = NSStringFromClass([instanceUserdata->instance class]);
    if([des rangeOfString:@"Block__"].length > 0){//block called. blk(x, y, z)
        return luaCallBlock(L);
    }else{
        luaL_error(L, "'%s' is not block, so it can't be called", [instanceUserdata->instance description].UTF8String);
    }
    return 0;
}


static int __index(lua_State *L) {
    wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 1, WAX_INSTANCE_METATABLE_NAME);
    
    const char *luaIndexSelector = lua_tostring(L, 2);
    
    //replace WAX_ORIGINAL_METHOD_PREFIX->WAX_REPLACE_METHOD_PREFIX, because ORIG may confilt with some other AOP lib
    if(wax_stringHasPrefix(luaIndexSelector, WAX_ORIGINAL_METHOD_PREFIX)){
        char *newSelectorName = alloca(strlen(WAX_REPLACE_METHOD_PREFIX) + strlen(luaIndexSelector)+1);
        strcpy(newSelectorName, WAX_REPLACE_METHOD_PREFIX);
        strcat(newSelectorName, luaIndexSelector+strlen(WAX_ORIGINAL_METHOD_PREFIX));
        luaIndexSelector = newSelectorName;
    }
    
    if (lua_isstring(L, 2) && strcmp("super", luaIndexSelector) == 0) { // call to super!
        wax_instance_createSuper(L, instanceUserdata);
        return 1;
    }
    
    // Check instance userdata, unless we are acting like a super
	if (!instanceUserdata->actAsSuper) {
		lua_getfenv(L, -2);
		lua_pushvalue(L, -2);
		lua_rawget(L, 3);
	}
	else { 
		lua_pushnil(L);
	}

    // Check instance's class userdata, or if it is a super, check the super's class data
    Class classToCheck = instanceUserdata->actAsSuper ? instanceUserdata->isSuper : [instanceUserdata->instance class];	
	while (lua_isnil(L, -1) && wax_instance_isWaxClass(classToCheck)) {
		// Keep checking superclasses if they are waxclasses, we want to treat those like they are lua
		lua_pop(L, 1);
		wax_instance_pushUserdata(L, classToCheck);
		
		// If there is no userdata for this instance's class, then leave the nil on the stack and don't anything else
		if (!lua_isnil(L, -1)) {
			lua_getfenv(L, -1);
			lua_pushvalue(L, 2);
			lua_rawget(L, -2);
			lua_remove(L, -2); // Get rid of the userdata env
			lua_remove(L, -2); // Get rid of the userdata
		}
		
		classToCheck = class_getSuperclass(classToCheck);
    }
            
    if (lua_isnil(L, -1)) { // If we are calling a super class, or if we couldn't find the index in the userdata environment table, assume it is defined in obj-c classes
        SEL foundSelectors[2] = {nil, nil};
        BOOL foundSelector = wax_selectorForInstance(instanceUserdata, foundSelectors, luaIndexSelector, NO);

        if (foundSelector) { // If the class has a method with this name, push as a closure
            
            if(instanceUserdata->actAsSuper){//super method, method_setImplementation is inefficient so add a super method for subclass
                for(int i = 0; i < 2; ++i){
                    SEL selector = foundSelectors[i];
                    SEL selfSuperSelector = wax_selectorWithPrefix(selector, WAX_SUPER_METHOD_PREFIX);
                    
                    Method selfSuperMethod = class_getInstanceMethod([instanceUserdata->instance class], selfSuperSelector);
                    Method superMethod = class_getInstanceMethod(instanceUserdata->isSuper, selector);
                    
                    if(!superMethod){
                        continue ;
                    }
                    
                    IMP superMethodImp = method_getImplementation(superMethod);
                    char *typeDescription = (char *)method_getTypeEncoding(superMethod);
                    id klass = [instanceUserdata->instance class];
                    //add SUPERselector for subclass
                    if (!selfSuperMethod){
                        class_addMethod(klass, selfSuperSelector, superMethodImp, typeDescription);
                    }
                }
                lua_pushstring(L, sel_getName(wax_selectorWithPrefix(foundSelectors[0], WAX_SUPER_METHOD_PREFIX)));
                foundSelectors[1] ? lua_pushstring(L, sel_getName(wax_selectorWithPrefix(foundSelectors[1], WAX_SUPER_METHOD_PREFIX))) : lua_pushnil(L);//
                lua_pushcclosure(L, methodClosure, 2);
            }else{
                lua_pushstring(L, sel_getName(foundSelectors[0]));
                foundSelectors[1] ? lua_pushstring(L, sel_getName(foundSelectors[1])) : lua_pushnil(L);//
                lua_pushcclosure(L, methodClosure, 2);
            }
        }
    }
    else if (!instanceUserdata->isSuper && instanceUserdata->isClass && wax_isInitMethod(luaIndexSelector)) { // Is this an init method create in lua?
        lua_pushcclosure(L, customInitMethodClosure, 1);
    }
	
	// Always reset this, an object only acts like a super ONE TIME!
	instanceUserdata->actAsSuper = NO;
    
    return 1;
}

static int __newindex(lua_State *L) {
    wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 1, WAX_INSTANCE_METATABLE_NAME);
    
    // If this already exists in a protocol, or superclass make sure it will call the lua functions
    if (instanceUserdata->isClass && lua_type(L, 3) == LUA_TFUNCTION) {
        overrideMethod(L, instanceUserdata);
    }

    // Add value to the userdata's environment table.
    lua_getfenv(L, 1);
    lua_insert(L, 2);
    lua_rawset(L, 2);
    
    return 0;
}

static int __gc(lua_State *L) {
    
    wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 1, WAX_INSTANCE_METATABLE_NAME);
    
//    wax_log(LOG_GC, @"Releasing %@ %@(%p)", instanceUserdata->isClass ? @"Class" : @"Instance", [instanceUserdata->instance class], instanceUserdata->instance);

    if (!instanceUserdata->isClass && !instanceUserdata->isSuper) {
        // This seems like a stupid hack. But...
        // If we want to call methods on an object durring gc, we have to readd 
        // the instance/userdata to the userdata table. Why? Because it is 
        // removed from the weak table before GC is called.
        wax_instance_pushUserdataTable(L);        
        lua_pushlightuserdata(L, instanceUserdata->instance);        
        lua_pushvalue(L, -3);
        lua_rawset(L, -3);
        
        [instanceUserdata->instance release];
        
        lua_pushlightuserdata(L, instanceUserdata->instance);        
        lua_pushnil(L);
        lua_rawset(L, -3);
        lua_pop(L, 1);        
    }
    
    return 0;
}

static int __tostring(lua_State *L) {
    wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 1, WAX_INSTANCE_METATABLE_NAME);
    lua_pushstring(L, [[NSString stringWithFormat:@"(%p => %p) %@", instanceUserdata, instanceUserdata->instance, instanceUserdata->instance] UTF8String]);
    
    return 1;
}

static int __eq(lua_State *L) {
    wax_instance_userdata *o1 = (wax_instance_userdata *)luaL_checkudata(L, 1, WAX_INSTANCE_METATABLE_NAME);
    wax_instance_userdata *o2 = (wax_instance_userdata *)luaL_checkudata(L, 2, WAX_INSTANCE_METATABLE_NAME);
    
    lua_pushboolean(L, [o1->instance isEqual:o2->instance]);
    return 1;
}

#pragma mark Userdata Functions
#pragma mark -----------------------

static int methods(lua_State *L) {
    wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 1, WAX_INSTANCE_METATABLE_NAME);
    
    uint count;
    Method *methods = class_copyMethodList([instanceUserdata->instance class], &count);
    
    lua_newtable(L);
    
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        lua_pushstring(L, sel_getName(method_getName(method)));
        lua_rawseti(L, -2, i + 1);
    }

    return 1;
}

#pragma mark Function Closures
#pragma mark ----------------------

static int methodClosure(lua_State *L) {
//    if (![[NSThread currentThread] isEqual:[NSThread mainThread]]) NSLog(@"METHODCLOSURE: OH NO SEPERATE THREAD");

    wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 1, WAX_INSTANCE_METATABLE_NAME);    
    const char *selectorName = luaL_checkstring(L, lua_upvalueindex(1));//

    // If the only arg is 'self' and there is a selector with no args. USE IT!
    if (lua_gettop(L) == 1 && lua_isstring(L, lua_upvalueindex(2))) {
        selectorName = luaL_checkstring(L, lua_upvalueindex(2));
    }
    
    SEL selector = sel_getUid(selectorName);
    id instance = instanceUserdata->instance;
    BOOL autoAlloc = NO;
        
    // If init is called on a class, auto-allocate it.    
    if (instanceUserdata->isClass && wax_isInitMethod(selectorName)) {
        autoAlloc = YES;
        instance = [instance alloc];//retainCount is 1
    }
    
    NSMethodSignature *signature = [instance methodSignatureForSelector:selector];
    if (!signature) {
        const char *className = [NSStringFromClass([instance class]) UTF8String];
        luaL_error(L, "'%s' has no method selector '%s'", className, selectorName);
    }
    
    NSInvocation *invocation = nil;
    invocation = [NSInvocation invocationWithMethodSignature:signature];
        
    [invocation setTarget:instance];
    [invocation setSelector:selector];
    
    int objcArgumentCount = (int)[signature numberOfArguments] - 2; // skip the hidden self and _cmd argument
    int luaArgumentCount = lua_gettop(L) - 1;
    
    
    if (objcArgumentCount > luaArgumentCount && !wax_instance_isWaxClass(instance)) { 
        luaL_error(L, "Not Enough arguments given! Method named '%s' requires %d argument(s), you gave %d. (Make sure you used ':' to call the method)", selectorName, objcArgumentCount + 1, lua_gettop(L));
    }
    
    void **arguements = calloc(sizeof(void*), objcArgumentCount);
    for (int i = 0; i < objcArgumentCount; i++) {
        arguements[i] = wax_copyToObjc(L, [signature getArgumentTypeAtIndex:i + 2], i + 2, nil);
        [invocation setArgument:arguements[i] atIndex:i + 2];
    }

    @try {
        [invocation invoke];
    }
    @catch (NSException *exception) {
        luaL_error(L, "Error invoking method '%s' on '%s' because %s", selector, class_getName([instance class]), [[exception description] UTF8String]);
    }
    
    for (int i = 0; i < objcArgumentCount; i++) {
        free(arguements[i]);
    }
    free(arguements);
    
    size_t methodReturnLength = [signature methodReturnLength];
    if (methodReturnLength > 0) {
        void *buffer = calloc(1, methodReturnLength);
        [invocation getReturnValue:buffer];
            
        wax_fromObjc(L, [signature methodReturnType], buffer);
                
        if (autoAlloc) {
            if (lua_isnil(L, -1)) {
                // The init method returned nil... means initialization failed!
                // Remove it from the userdataTable (We don't ever want to clean up after this... it should have cleaned up after itself)
                wax_instance_pushUserdataTable(L);
                lua_pushlightuserdata(L, instance);
                lua_pushnil(L);
                lua_rawset(L, -3);
                lua_pop(L, 1); // Pop the userdataTable
                
                lua_pushnil(L);
                [instance release];
            }
            else {
                wax_instance_userdata *returnedInstanceUserdata = (wax_instance_userdata *)lua_topointer(L, -1);
                if (returnedInstanceUserdata) { // Could return nil
                    [returnedInstanceUserdata->instance release]; // Wax automatically retains a copy of the object, so the alloc needs to be released retainCount-1
                }
            }            
        }
        
        free(buffer);
    }
    
    return 1;
}

static int superMethodClosure(lua_State *L) {
    wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 1, WAX_INSTANCE_METATABLE_NAME);
    int upvalueIndex = 1;
    const char *selectorName = luaL_checkstring(L, lua_upvalueindex(1));

    // If the only arg is 'self' and there is a selector with no args. USE IT!
    if (lua_gettop(L) == 1 && lua_isstring(L, lua_upvalueindex(2))) {
        selectorName = luaL_checkstring(L, lua_upvalueindex(2));
        upvalueIndex = 2;
    }
    
    SEL selector = sel_getUid(selectorName);
    
    // Super Swizzle
    Method selfMethod = class_getInstanceMethod([instanceUserdata->instance class], selector);
    Method superMethod = class_getInstanceMethod(instanceUserdata->isSuper, selector);        
    
    if (superMethod && selfMethod != superMethod) { // Super's got what you're looking for
        IMP selfMethodImp = method_getImplementation(selfMethod);        
        IMP superMethodImp = method_getImplementation(superMethod);

        
        char *typeDescription = (char *)method_getTypeEncoding(selfMethod);
        
        const char *selectorName = sel_getName(selector);
        char newSelectorName[strlen(selectorName) + strlen(WAX_SUPER_METHOD_PREFIX)+1];
        strcpy(newSelectorName, WAX_SUPER_METHOD_PREFIX);
        strcat(newSelectorName, selectorName);
        SEL newSelector = sel_getUid(newSelectorName);
        id klass = [instanceUserdata->instance class];
        if(!class_respondsToSelector(klass, newSelector)) {
            class_addMethod(klass, newSelector, superMethodImp, typeDescription);
        }

        lua_setupvalue (L, -1, lua_upvalueindex(upvalueIndex));
        
        method_setImplementation(selfMethod, superMethodImp);
        
        methodClosure(L);
        
        method_setImplementation(selfMethod, selfMethodImp); // Swap back to self's original method
    }
    else {
        methodClosure(L);
    }
    
    return 1;
}

static int customInitMethodClosure(lua_State *L) {
    wax_instance_userdata *classInstanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 1, WAX_INSTANCE_METATABLE_NAME);
    wax_instance_userdata *instanceUserdata = nil;
	
    id instance = nil;
    BOOL shouldRelease = NO;
    if (classInstanceUserdata->isClass) {
        shouldRelease = YES;
        instance = [classInstanceUserdata->instance alloc];
        instanceUserdata = wax_instance_create(L, instance, NO);
        lua_replace(L, 1); // replace the old userdata with the new one!
    }
    else {
        luaL_error(L, "I WAS TOLD THIS WAS A CUSTOM INIT METHOD. BUT YOU LIED TO ME");
        return -1;
    }
    
    lua_pushvalue(L, lua_upvalueindex(1)); // Grab the function!
    lua_insert(L, 1); // push it up top
    
    if (wax_pcall(L, lua_gettop(L) - 1, 1)) {
        const char* errorString = lua_tostring(L, -1);
        luaL_error(L, "Custom init method on '%s' failed.\n%s", class_getName([instanceUserdata->instance class]), errorString);
    }
    
    if (shouldRelease) {
        [instance release];
    }
    
    if (lua_isnil(L, -1)) { // The init method returned nil... return the instanceUserdata instead
		luaL_error(L, "Init method must return the self");
    }
  
    return 1;
}

#pragma mark Override Methods
#pragma mark ---------------------

//64 solve 1:instance method go Invocation
static int pcallUserdataARM64Invocation(lua_State *L, id self, SEL selector, NSInvocation *anInvocation) {
    BEGIN_STACK_MODIFY(L)
    
//    if (![[NSThread currentThread] isEqual:[NSThread mainThread]]) NSLog(@"PCALLUSERDATA: OH NO SEPERATE THREAD");
    
    // A WaxClass could have been created via objective-c (like via NSKeyUnarchiver)
    // In this case, no lua object was ever associated with it, so we've got to
    // create one.
    if (wax_instance_isWaxClass(self)) {
        BOOL isClass = self == [self class];
        wax_instance_create(L, self, isClass); // If it already exists, then it will just return without doing anything
        lua_pop(L, 1); // Pops userdata off
    }
    
    // Find the function... could be in the object or in the class
    if (!wax_instance_pushFunction(L, self, selector)) {
        lua_pushfstring(L, "Could not find function named \"%s\" associated with object %s(%p).(It may have been released by the GC)", selector, class_getName([self class]), self);
        goto error; // function not found in userdata...
    }
    
    // Push userdata as the first argument
    wax_fromInstance(L, self);
    if (lua_isnil(L, -1)) {
        lua_pushfstring(L, "Could not convert '%s' into lua", class_getName([self class]));
        goto error;
    }
    
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    int nargs = (int)[signature numberOfArguments] - 1; // Don't send in the _cmd argument, only self
    int nresults = [signature methodReturnLength] ? 1 : 0;
    
    for (NSUInteger i = 2; i < [signature numberOfArguments]; i++) { // start at 2 because to skip the automatic self and _cmd arugments
        const char *type = [signature getArgumentTypeAtIndex:i];
        const char *typeDescription = wax_removeProtocolEncodings(type);
        
        NSUInteger size = 0;
        NSGetSizeAndAlignment(type, &size, NULL);
        
        void *buffer = malloc(size);
        [anInvocation getArgument:buffer atIndex:i];
        
        wax_fromObjc(L, typeDescription, buffer);
        free(buffer);
    }
    
    if (wax_pcall(L, nargs, nresults)) { // Userdata will allways be the first object sent to the function
        goto error;
    }
    
    END_STACK_MODIFY(L, nresults)
    return nresults;
    
error:
    END_STACK_MODIFY(L, 1)
    return -1;
}

////64bit solve : imp pointer
static int pcallUserdataARM64ImpCall(lua_State *L, id self, SEL selector, va_list args) {
    BEGIN_STACK_MODIFY(L)
    
//    if (![[NSThread currentThread] isEqual:[NSThread mainThread]]) NSLog(@"PCALLUSERDATA: OH NO SEPERATE THREAD");
    
    // A WaxClass could have been created via objective-c (like via NSKeyUnarchiver)
    // In this case, no lua object was ever associated with it, so we've got to
    // create one.
    if (wax_instance_isWaxClass(self)) {
        BOOL isClass = self == [self class];
        wax_instance_create(L, self, isClass); // If it already exists, then it will just return without doing anything
        lua_pop(L, 1); // Pops userdata off
    }
    
    // Find the function... could be in the object or in the class
    if (!wax_instance_pushFunction(L, self, selector)) {
        lua_pushfstring(L, "Could not find function named \"%s\" associated with object %s(%p).(It may have been released by the GC)", selector, class_getName([self class]), self);
        goto error; // function not found in userdata...
    }
    
    // Push userdata as the first argument
    wax_fromInstance(L, self);
    if (lua_isnil(L, -1)) {
        lua_pushfstring(L, "Could not convert '%s' into lua", class_getName([self class]));
        goto error;
    }
    
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    NSUInteger nargs = [signature numberOfArguments] - 1; // Don't send in the _cmd argument, only self
    int nresults = [signature methodReturnLength] ? 1 : 0;
    
    for (NSUInteger i = 2; i < [signature numberOfArguments]; i++) { // start at 2 because to skip the automatic self and _cmd arugments
        const char *type = [signature getArgumentTypeAtIndex:i];
        const char *typeDescription = wax_removeProtocolEncodings(type);
        
        void *buffer = va_arg(args, void*);
        wax_fromObjc(L, typeDescription, buffer);
    }
    
    if (wax_pcall(L, (int)nargs, nresults)) { // Userdata will allways be the first object sent to the function
        goto error;
    }
    
    END_STACK_MODIFY(L, nresults)
    return nresults;
    
error:
    END_STACK_MODIFY(L, 1)
    return -1;
}

// Only allow classes to do this
static BOOL overrideMethod(lua_State *L, wax_instance_userdata *instanceUserdata) {
    BEGIN_STACK_MODIFY(L);
    BOOL success = NO;
    const char *methodName = lua_tostring(L, 2);
    
    SEL foundSelectors[2] = {nil, nil};
    wax_selectorForInstance(instanceUserdata, foundSelectors, methodName, YES);
    SEL selector = foundSelectors[0];
    if (foundSelectors[1]) {
        //NSLog(@"Found two selectors that match %s. Defaulting to %s over %s", methodName, foundSelectors[0], foundSelectors[1]);
    }
//    NSLog(@"overrideMethodByInvocation selector=%s F:%s L:%d", selector, __PRETTY_FUNCTION__, __LINE__);
    Class klass = [instanceUserdata->instance class];
    
    char *typeDescription = nil;
    char *returnType = nil;
    
    Method method = class_getInstanceMethod(klass, selector);
    
    if (method) { // Is method defined in the superclass?
        typeDescription = (char *)method_getTypeEncoding(method);
        returnType = method_copyReturnType(method);
    }
    else { // Is this method implementing a protocol?
        Class currentClass = klass;
        
        while (!returnType && [currentClass superclass] != [currentClass class]) { // Walk up the object heirarchy
            uint count;
            Protocol **protocols = class_copyProtocolList(currentClass, &count);
            
            SEL possibleSelectors[2];
            wax_selectorsForName(methodName, possibleSelectors);
            
            for (int i = 0; !returnType && i < count; i++) {
                Protocol *protocol = protocols[i];
                struct objc_method_description m_description;
                
                for (int j = 0; !returnType && j < 2; j++) {
                    selector = possibleSelectors[j];
                    if (!selector) continue; // There may be only one acceptable selector sent back
                    
                    m_description = protocol_getMethodDescription(protocol, selector, YES, YES);
                    if (!m_description.name) m_description = protocol_getMethodDescription(protocol, selector, NO, YES); // Check if it is not a "required" method
                    
                    if (m_description.name) {
                        typeDescription = m_description.types;
                        returnType = method_copyReturnType((Method)&m_description);
                    }
                }
            }
            
            free(protocols);
            
            currentClass = [currentClass superclass];
        }
    }
    
    if (returnType) { // Matching method found! Create an Obj-C method on the
        if (!instanceUserdata->isClass) {
            luaL_error(L, "Trying to override method '%s' on an instance. You can only override classes", methodName);
        }
        
        success = overrideMethodByInvocation(klass, selector, typeDescription,returnType);
        free(returnType);
        returnType = nil;
    }
    else {
        SEL possibleSelectors[2];
        wax_selectorsForName(methodName, possibleSelectors);
        
        success = YES;
        for (int i = 0; i < 2; i++) {
            selector = possibleSelectors[i];
            if (!selector) continue; // There may be only one acceptable selector sent back
            
            int argCount = 0;
            char *match = (char *)sel_getName(selector);
            while ((match = strchr(match, ':'))) {
                match += 1; // Skip past the matched char
                argCount++;
            }
            
            id metaclass = objc_getMetaClass(object_getClassName(klass));
            
            IMP metaImp = class_respondsToSelector(metaclass, selector) ? class_getMethodImplementation(metaclass, selector) : NULL;
            if(metaImp) {//has class method
                Method method = class_getClassMethod(klass, selector);
                typeDescription = (char *)method_getTypeEncoding(method);
                char *tempReturnType = method_copyReturnType(method);
                
                success = overrideMethodByInvocation(metaclass, selector, typeDescription, tempReturnType);
                if(tempReturnType){
                    free(tempReturnType);
                    tempReturnType = nil;
                }
            } else {//no method, then add it both
                
                size_t typeDescriptionSize = 3 + argCount;
                typeDescription = calloc(typeDescriptionSize + 1, sizeof(char));
                memset(typeDescription, '@', typeDescriptionSize);//default id
                typeDescription[2] = ':'; // Never forget _cmd!
                
                addMethodByInvocation(klass, selector, typeDescription);
                addMethodByInvocation(metaclass, selector, typeDescription);
                
                free(typeDescription);
            }
        }
    }
    
    END_STACK_MODIFY(L, 1)
    return success;
}

//all method hook by wax will generate a method with WAX_REPLACE_METHOD_PREFIX
static BOOL isMethodReplacedByWax(id klass, SEL selector){
    SEL replaceSelector =  wax_selectorWithPrefix(selector, WAX_REPLACE_METHOD_PREFIX);
    Method selectorMethod = class_getInstanceMethod(klass, replaceSelector);
    return selectorMethod != nil;
}

static void replaceAndGenerateWaxPrefixMethod(id klass, SEL selector, IMP newIMP){
    Method selectorMethod = class_getInstanceMethod(klass, selector);
    const char *typeDescription =  method_getTypeEncoding(selectorMethod);
    IMP prevImp = class_getMethodImplementation(klass, selector);
    
    class_replaceMethod(klass, selector, newIMP, typeDescription);
    if(prevImp == nil ){//|| prevImp == newIMP
        return ;
    }
    
    //add wax prefix method
    SEL newSelector = wax_selectorWithPrefix(selector, WAX_REPLACE_METHOD_PREFIX);
    if(!class_respondsToSelector(klass, newSelector)) {
        class_addMethod(klass, newSelector, prevImp, typeDescription);
    }
}

static void waxForwardInvocation(id self, SEL sel, NSInvocation *anInvocation){
//    NSLog(@"self=%@ sel=%s", self, anInvocation.selector);
//    NSLog(@"Fun:%s Line:%d", __PRETTY_FUNCTION__, __LINE__);
    if(isMethodReplacedByWax(object_getClass(self), anInvocation.selector)){//instance->class, class->metaClass
//        NSLog(@"Fun:%s Line:%d", __PRETTY_FUNCTION__, __LINE__);
        lua_State *L = wax_currentLuaState();
        BEGIN_STACK_MODIFY(L);
        int result = pcallUserdataARM64Invocation(L, self, anInvocation.selector, anInvocation);
        if (result == -1) {//error
            if(wax_getLuaRuntimeErrorHandler()){
                wax_getLuaRuntimeErrorHandler()([NSString stringWithFormat:@"Error calling '%s' on '%@'\n%s", sel_getName(anInvocation.selector), self, lua_tostring(L, -1)], NO);
            }else{
                luaL_error(L, "Error calling '%s' on '%s'\n%s", anInvocation.selector, [[self description] UTF8String], lua_tostring(L, -1));
            }
        }
        else if (result == 1) {//have return value
            NSMethodSignature *signature = [self methodSignatureForSelector:anInvocation.selector];
            void *pReturnValue = wax_copyToObjc(L, [signature methodReturnType], -1, nil);
            [anInvocation setReturnValue:pReturnValue];
            free(pReturnValue);
        }
        END_STACK_MODIFY(L, 0);
    }else{
        //cal original forwardInvocation method. case1:the method doesn't exist. case2:the method is hook by other AOP such as aspects, so we need to give the no prefix method name.
        SEL origForwardSelector = wax_selectorWithPrefix(@selector(forwardInvocation:), WAX_REPLACE_METHOD_PREFIX);
        const char *selCString = sel_getName(anInvocation.selector);
        if(wax_stringHasPrefix(selCString, WAX_REPLACE_METHOD_PREFIX)){
            size_t selLen = strlen(selCString);
            size_t prefixLen = strlen(WAX_REPLACE_METHOD_PREFIX);
            char *origCallSelector = alloca(selLen+1);
            memset(origCallSelector, 0, selLen+1);
            strncpy(origCallSelector, selCString+prefixLen, selLen - prefixLen);
            [anInvocation setSelector:sel_getUid(origCallSelector)];
        }
        ((void(*)(id, SEL, id))objc_msgSend)(self, origForwardSelector, anInvocation);
    };
}

static BOOL overrideMethodByInvocation(id klass, SEL selector, char *typeDescription, char *returnType) {
    IMP forwardImp = _objc_msgForward;
#if !defined(__arm64__)
    if(strlen(returnType) > 0 && returnType[0] == '{'){//return struct
        NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:typeDescription];
        if ([methodSignature.debugDescription rangeOfString:@"is special struct return? YES"].location != NSNotFound) {
            forwardImp = (IMP)_objc_msgForward_stret;
        }
    }
#endif
    
    //first replace forwardInvocation then forwardImp, because of some mutithread cases
    if(!isMethodReplacedByWax(klass, @selector(forwardInvocation:))){//just replace once
        replaceAndGenerateWaxPrefixMethod(klass, @selector(forwardInvocation:), (IMP)waxForwardInvocation);
    }
    
    replaceAndGenerateWaxPrefixMethod(klass, selector, forwardImp);//trigger forwardInvocation
    return YES;
}

static BOOL addMethodByInvocation(id klass, SEL selector, char * typeDescription) {
    if(!isMethodReplacedByWax(klass, @selector(forwardInvocation:))){//just replace once
        replaceAndGenerateWaxPrefixMethod(klass, @selector(forwardInvocation:), (IMP)waxForwardInvocation);
    }
    class_addMethod(klass, selector, _objc_msgForward, typeDescription);//for isMethodReplacedByInvocation
    
    //add wax prefix method
    SEL newSelector = wax_selectorWithPrefix(selector, WAX_REPLACE_METHOD_PREFIX);
    if(!class_respondsToSelector(klass, newSelector)) {
        class_addMethod(klass, newSelector, _objc_msgForward, typeDescription);
    }
    return YES;
}