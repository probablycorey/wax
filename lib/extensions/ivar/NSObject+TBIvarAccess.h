//
//  NSObject+TBIvarAccess.h
//  TBTestRuntimeGetVar
//
//  Created by lv on 14-2-28.
//  Copyright (c) 2014年 TB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@interface TBIvarInfo : NSObject
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;

- (id)initWithName:(NSString *)aName type:(NSString *)aType;
+ (TBIvarInfo *)ivarInfoWithName:(NSString *)aName type:(NSString *)aType;
@end


#pragma mark ///////////////////////////////////////////////////
@interface NSObject (TBIvarAccess)
#pragma mark - Getter -
- (NSArray *)getIvars;
- (Ivar)getIvar:(NSString *)ivarName;
- (id)getIvarObject:(NSString *)ivarName;

- (char)getIvarChar:(NSString *)ivarName;
- (short)getIvarShort:(NSString *)ivarName;
- (int)getIvarInt:(NSString *)ivarName;
- (long)getIvarLong:(NSString *)ivarName;
- (NSInteger)getIvarInteger:(NSString *)ivarName;
- (long long)getIvarLongLong:(NSString *)ivarName;

- (unsigned char)getIvarUnsignedChar:(NSString *)ivarName;
- (unsigned short)getIvarUnsignedShort:(NSString *)ivarName;
- (unsigned int)getIvarUnsignedInt:(NSString *)ivarName;
- (unsigned long)getIvarUnsignedLong:(NSString *)ivarName;
- (unsigned long long)getIvarUnsignedLongLong:(NSString *)ivarName;

- (float)getIvarFloat:(NSString *)ivarName;
- (double)getIvarDouble:(NSString *)ivarName;
- (CGFloat)getIvarCGFloat:(NSString *)ivarName;

- (BOOL)getIvarBool:(NSString *)ivarName;
- (void *)getIvarPointer:(NSString *)ivarName;

- (CGPoint)getIvarCGPoint:(NSString *)ivarName;
- (CGSize)getIvarCGSize:(NSString *)ivarName;
- (CGRect)getIvarCGRect:(NSString *)ivarName;

#pragma mark - Setter -
- (void)setIvar:(NSString *)ivarName withObject:(id)anObject;

- (void)setIvar:(NSString *)ivarName withChar:(char)aScalar;
- (void)setIvar:(NSString *)ivarName withShort:(short)aScalar;
- (void)setIvar:(NSString *)ivarName withInt:(int)aScalar;
- (void)setIvar:(NSString *)ivarName withLong:(long)aScalar;
- (void)setIvar:(NSString *)ivarName withInteger:(NSInteger)aScalar;
- (void)setIvar:(NSString *)ivarName withLongLong:(long long)aScalar;

- (void)setIvar:(NSString *)ivarName withUnsignedChar:(unsigned char)aScalar;
- (void)setIvar:(NSString *)ivarName withUnsignedShort:(unsigned short)aScalar;
- (void)setIvar:(NSString *)ivarName withUnsignedInt:(unsigned int)aScalar;
- (void)setIvar:(NSString *)ivarName withUnsignedLong:(unsigned long)aScalar;
- (void)setIvar:(NSString *)ivarName withUnsignedLongLong:(unsigned long long)aScalar;

- (void)setIvar:(NSString *)ivarName withFloat:(float)aScalar;
- (void)setIvar:(NSString *)ivarName withDouble:(double)aScalar;
- (void)setIvar:(NSString *)ivarName withCGFloat:(CGFloat)aScalar;
- (void)setIvar:(NSString *)ivarName withBool:(_Bool)aScalar;
- (void)setIvar:(NSString *)ivarName withPointer:(void *)aScalar;

- (void)setIvar:(NSString *)ivarName withCGPoint:(CGPoint)aPoint;
- (void)setIvar:(NSString *)ivarName withCGSize:(CGSize)aSize;
- (void)setIvar:(NSString *)ivarName withCGRect:(CGRect)aRect;

@end

