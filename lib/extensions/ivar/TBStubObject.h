//
//  TBStubObject.h
//  TBTestRuntimeGetVar
//
//  Created by lv on 14-2-28.
//  Copyright (c) 2014年 TB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TBStubObject : NSObject{
    @private
    
    char        _privateChar;
    short       _privateShort;
    int         _privateInt;
    long        _privateLong;
    long long   _privateLongLong;
    float       _privateFloat;
    double      _privateDouble;
    
    unsigned char   _privateUnsignedChar;
    unsigned short  _privateUnsignedShort;
    unsigned int    _privateUnsignedInt;
    unsigned long   _privateUnsignedLong;
    unsigned long long _privateUnsignedLongLong;
    
    BOOL            _privateBool;
    void            *_privatePointer;
    id              _privateObject;
    
    CGFloat         _privateCGFloat;
    
    CGPoint     _privatePoint;
    CGSize      _privateSize;
    CGRect      _privateRect;
    
    //others
    NSString    *_privateName;
    NSString    *_privateAge;
    
}
@property(nonatomic, strong)NSString* name;
@property(nonatomic, assign)CGFloat   age;
@property(nonatomic, assign)CGPoint  point;
@property(nonatomic, assign)CGSize   size;
@property(nonatomic, assign)CGRect   rect;

- (void)sayHello;
@end
