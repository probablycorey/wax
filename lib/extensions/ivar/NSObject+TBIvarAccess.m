//
//  NSObject+TBIvarAccess.m
//  TBTestRuntimeGetVar
//
//  Created by lv on 14-2-28.
//  Copyright (c) 2014年 TB. All rights reserved.
//

#import "NSObject+TBIvarAccess.h"
#import <objc/runtime.h>
#import <objc/message.h>


#if __has_feature(objc_arc)
#define GETADDRESS(X) (const char *)(__bridge const void *)(X)
#else
#define GETADDRESS(X) (const char *)(X)
#endif


@implementation TBIvarInfo
@synthesize name,type;
- (id)initWithName:(NSString *)aName type:(NSString *)aType{
	if ((self = [super init])) {
		self.name = aName;
		self.type = aType;
	}
	return self;
}

+ (TBIvarInfo *)ivarInfoWithName:(NSString *)aName type:(NSString *)aType{
	TBIvarInfo * obj = [[TBIvarInfo alloc] initWithName:aName type:aType];
#if !__has_feature(objc_arc)
	return [obj autorelease];
#else
	return obj;
#endif
}

- (NSString *)description{
    NSMutableString *des = [NSMutableString stringWithCapacity:0];
    [des appendFormat:@"\n----------TBIvarInfo----------\n"];
    [des appendFormat:@"name    = %@\n", name];
    [des appendFormat:@"type    = %@\n", type];
    [des appendString:@"----------TBIvarInfo----------\n"];
    return des;
}

#if !__has_feature(objc_arc)
- (void)dealloc {
	self.name = nil;
	self.type = nil;
	[super dealloc];
}
#endif
@end

#pragma mark ///////////////////////////////////////////////////
@implementation NSObject (TBIvarAccess)

- (NSArray *)getIvars {
	unsigned int count = 0;
	Ivar * ivars = class_copyIvarList([self class], &count);
	if (!ivars) {
		return [NSArray array];
	}
	
	NSMutableArray * infoObjects = [[NSMutableArray alloc] initWithCapacity:count];
	for (unsigned int i = 0; i < count; i++) {
		Ivar anIvar = ivars[i];
		NSString * name = [NSString stringWithUTF8String:ivar_getName(anIvar)];
		NSString * type = [NSString stringWithUTF8String:ivar_getTypeEncoding(anIvar)];
		[infoObjects addObject:[TBIvarInfo ivarInfoWithName:name type:type]];
	}
	
	free(ivars);
	
#if __has_feature(objc_arc)
	return [infoObjects copy]; // create immutable copy
#else
	NSArray * immutable = [NSArray arrayWithArray:infoObjects];
	[infoObjects release];
	return immutable;
#endif
}

#pragma mark - Getters -

- (Ivar)getIvar:(NSString *)ivarName {
	Ivar ivar = class_getInstanceVariable([self class], [ivarName UTF8String]);
    //Ivar ivar = class_getInstanceVariable([self class], [ivarName UTF8String]);
	if (!ivar) {
		@throw [NSException exceptionWithName:@"IvarNotFoundException"
									   reason:@"The ivar specified does not exist."
									 userInfo:nil];
	}
	return ivar;
}

- (id)getIvarObject:(NSString *)ivarName {
	Ivar ivar = [self getIvar:ivarName];
	return object_getIvar(self, ivar);
}

- (char)getIvarChar:(NSString *)ivarName {
	Ivar ivar = [self getIvar:ivarName];
	return *(GETADDRESS(self) + ivar_getOffset(ivar));
}

- (short)getIvarShort:(NSString *)ivarName {
	Ivar ivar = [self getIvar:ivarName];
	return *(short *)(GETADDRESS(self) + ivar_getOffset(ivar));
}

- (int)getIvarInt:(NSString *)ivarName {
	Ivar ivar = [self getIvar:ivarName];
	return *(int *)(GETADDRESS(self) + ivar_getOffset(ivar));
}

- (long)getIvarLong:(NSString *)ivarName {
	Ivar ivar = [self getIvar:ivarName];
	return *(long *)(GETADDRESS(self) + ivar_getOffset(ivar));
}

- (NSInteger)getIvarInteger:(NSString *)ivarName {
    Ivar ivar = [self getIvar:ivarName];
    return *(NSInteger *)(GETADDRESS(self) + ivar_getOffset(ivar));
}

- (long long)getIvarLongLong:(NSString *)ivarName {
	Ivar ivar = [self getIvar:ivarName];
	return *(long long *)(GETADDRESS(self) + ivar_getOffset(ivar));
}


- (unsigned char)getIvarUnsignedChar:(NSString *)ivarName {
	Ivar ivar = [self getIvar:ivarName];
	return *(unsigned char *)(GETADDRESS(self) + ivar_getOffset(ivar));
}

- (unsigned short)getIvarUnsignedShort:(NSString *)ivarName {
	Ivar ivar = [self getIvar:ivarName];
	return *(unsigned short *)(GETADDRESS(self) + ivar_getOffset(ivar));
}

- (unsigned int)getIvarUnsignedInt:(NSString *)ivarName {
	Ivar ivar = [self getIvar:ivarName];
	return *(unsigned int *)(GETADDRESS(self) + ivar_getOffset(ivar));
}

- (unsigned long)getIvarUnsignedLong:(NSString *)ivarName {
	Ivar ivar = [self getIvar:ivarName];
	return *(unsigned long *)(GETADDRESS(self) + ivar_getOffset(ivar));
}

- (unsigned long long)getIvarUnsignedLongLong:(NSString *)ivarName {
	Ivar ivar = [self getIvar:ivarName];
	return *(unsigned long long *)(GETADDRESS(self) + ivar_getOffset(ivar));
}


- (float)getIvarFloat:(NSString *)ivarName {
	Ivar ivar = [self getIvar:ivarName];
	return *(float *)(GETADDRESS(self) + ivar_getOffset(ivar));
}

- (double)getIvarDouble:(NSString *)ivarName {
	Ivar ivar = [self getIvar:ivarName];
	return *(double *)(GETADDRESS(self) + ivar_getOffset(ivar));
}

- (CGFloat)getIvarCGFloat:(NSString *)ivarName {
    Ivar ivar = [self getIvar:ivarName];
    return *(CGFloat *)(GETADDRESS(self) + ivar_getOffset(ivar));
}

- (BOOL)getIvarBool:(NSString *)ivarName {
	Ivar ivar = [self getIvar:ivarName];
	return *(BOOL *)(GETADDRESS(self) + ivar_getOffset(ivar));
}

- (void *)getIvarPointer:(NSString *)ivarName {
	Ivar ivar = [self getIvar:ivarName];
	return *(void **)(GETADDRESS(self) + ivar_getOffset(ivar));
}

- (CGPoint)getIvarCGPoint:(NSString *)ivarName{
  	Ivar ivar = [self getIvar:ivarName];
	return *(CGPoint *)(GETADDRESS(self) + ivar_getOffset(ivar));
}

- (CGSize)getIvarCGSize:(NSString *)ivarName{
  	Ivar ivar = [self getIvar:ivarName];
	return *(CGSize *)(GETADDRESS(self) + ivar_getOffset(ivar));
}

- (CGRect)getIvarCGRect:(NSString *)ivarName{
    Ivar ivar = [self getIvar:ivarName];
	return *(CGRect *)(GETADDRESS(self) + ivar_getOffset(ivar));
}
    
#pragma mark - Setters -

- (void)setIvar:(NSString *)ivarName withObject:(id)anObject {
	object_setIvar(self, [self getIvar:ivarName], anObject);
#if !__has_feature(objc_arc)
	[anObject retain];
#endif
}


- (void)setIvar:(NSString *)ivarName withChar:(char)aScalar {
	Ivar ivar = [self getIvar:ivarName];
	*(char *)(GETADDRESS(self) + ivar_getOffset(ivar)) = aScalar;
}

- (void)setIvar:(NSString *)ivarName withShort:(short)aScalar {
	Ivar ivar = [self getIvar:ivarName];
	*(short *)(GETADDRESS(self) + ivar_getOffset(ivar)) = aScalar;
}

- (void)setIvar:(NSString *)ivarName withInt:(int)aScalar {
	Ivar ivar = [self getIvar:ivarName];
	*(int *)(GETADDRESS(self) + ivar_getOffset(ivar)) = aScalar;
}

- (void)setIvar:(NSString *)ivarName withLong:(long)aScalar {
	Ivar ivar = [self getIvar:ivarName];
	*(long *)(GETADDRESS(self) + ivar_getOffset(ivar)) = aScalar;
}

- (void)setIvar:(NSString *)ivarName withInteger:(NSInteger)aScalar {
    Ivar ivar = [self getIvar:ivarName];
    *(NSInteger *)(GETADDRESS(self) + ivar_getOffset(ivar)) = aScalar;
}

- (void)setIvar:(NSString *)ivarName withLongLong:(long long)aScalar {
	Ivar ivar = [self getIvar:ivarName];
	*(long long *)(GETADDRESS(self) + ivar_getOffset(ivar)) = aScalar;
}


- (void)setIvar:(NSString *)ivarName withUnsignedChar:(unsigned char)aScalar {
	Ivar ivar = [self getIvar:ivarName];
	*(unsigned char *)(GETADDRESS(self) + ivar_getOffset(ivar)) = aScalar;
}

- (void)setIvar:(NSString *)ivarName withUnsignedShort:(unsigned short)aScalar {
	Ivar ivar = [self getIvar:ivarName];
	*(unsigned short *)(GETADDRESS(self) + ivar_getOffset(ivar)) = aScalar;
}

- (void)setIvar:(NSString *)ivarName withUnsignedInt:(unsigned int)aScalar {
	Ivar ivar = [self getIvar:ivarName];
	*(unsigned int *)(GETADDRESS(self) + ivar_getOffset(ivar)) = aScalar;
}

- (void)setIvar:(NSString *)ivarName withUnsignedLong:(unsigned long)aScalar {
	Ivar ivar = [self getIvar:ivarName];
	*(unsigned long *)(GETADDRESS(self) + ivar_getOffset(ivar)) = aScalar;
}

- (void)setIvar:(NSString *)ivarName withUnsignedLongLong:(unsigned long long)aScalar {
	Ivar ivar = [self getIvar:ivarName];
	*(unsigned long long *)(GETADDRESS(self) + ivar_getOffset(ivar)) = aScalar;
}

- (void)setIvar:(NSString *)ivarName withFloat:(float)aScalar {
	Ivar ivar = [self getIvar:ivarName];
	*(float *)(GETADDRESS(self) + ivar_getOffset(ivar)) = aScalar;
}

- (void)setIvar:(NSString *)ivarName withDouble:(double)aScalar {
	Ivar ivar = [self getIvar:ivarName];
	*(double *)(GETADDRESS(self) + ivar_getOffset(ivar)) = aScalar;
}

- (void)setIvar:(NSString *)ivarName withCGFloat:(CGFloat)aScalar {
    Ivar ivar = [self getIvar:ivarName];
    *(CGFloat *)(GETADDRESS(self) + ivar_getOffset(ivar)) = aScalar;
}

- (void)setIvar:(NSString *)ivarName withBool:(_Bool)aScalar {
	Ivar ivar = [self getIvar:ivarName];
	*(_Bool *)(GETADDRESS(self) + ivar_getOffset(ivar)) = aScalar;
}

- (void)setIvar:(NSString *)ivarName withPointer:(void *)aScalar {
	Ivar ivar = [self getIvar:ivarName];
	*(void **)(GETADDRESS(self) + ivar_getOffset(ivar)) = aScalar;
}

- (void)setIvar:(NSString *)ivarName withCGPoint:(CGPoint)aPoint{
	Ivar ivar = [self getIvar:ivarName];
    *(CGPoint *)(GETADDRESS(self) + ivar_getOffset(ivar)) = CGPointMake(aPoint.x, aPoint.y);
}

- (void)setIvar:(NSString *)ivarName withCGSize:(CGSize)aSize{
	Ivar ivar = [self getIvar:ivarName];
    *(CGSize *)(GETADDRESS(self) + ivar_getOffset(ivar)) = CGSizeMake(aSize.width, aSize.height);
}

- (void)setIvar:(NSString *)ivarName withCGRect:(CGRect)aRect{
    Ivar ivar = [self getIvar:ivarName];
    *(CGRect *)(GETADDRESS(self) + ivar_getOffset(ivar)) = CGRectMake(aRect.origin.x, aRect.origin.y, aRect.size.width, aRect.size.height);
}


@end
