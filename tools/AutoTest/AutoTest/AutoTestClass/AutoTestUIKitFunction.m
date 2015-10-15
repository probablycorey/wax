//
//  AutoTestUIKitFunction.m
//  
//
//  Created by junzhan on 15-4-21.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//

#import "AutoTestUIKitFunction.h"
#import "wax.h"
#include "lua.h"
#import "tolua++.h"
#import "AutoTestUtil.h"
#import <dispatch/queue.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@implementation AutoTestUIKitFunction

- (void)beforeAutoTestStart{
    lua_State *L = wax_currentLuaState();
    
    TOLUA_API int  tolua_UIKitFunction_open (lua_State* tolua_S);
    tolua_UIKitFunction_open(L);
    
    [AutoTestUtil runLuaFileInBundle:NSStringFromClass([self class])];
}


- (void)testNSFunction{
    //    NSStringFromClass(<#__unsafe_unretained Class aClass#>)
    //    NSClassFromString(<#NSString *aClassName#>)
//    NSStringFromCGRect(CGRectMake(0, 0, 10, 10));
//    NSStringFromCGSize(CGSizeMake(10, 10));
//    
//    TOLUA_API int  tolua_UIKitFunction_open (lua_State* tolua_S);
//    tolua_UIKitFunction_open(wax_currentLuaState());
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestLuaBindVC" ofType:@"lua"];
//    
//    NSError *eror = TBHP_runLuaFile(path);
//    if(eror){
//        NSLog(@"runLuaFile error=%@", eror);
//    }else{
//        NSLog(@"runLuaFile success");
//    }
//    
//    return ;
    UIImage *image = [UIImage imageNamed:@"mac_screen"];
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    NSLog(@"data.length=%d", data.length);
    
    data = UIImagePNGRepresentation(image);
    NSLog(@"data.length=%d", data.length);
    
    NSDictionary *info = @{@"key":@"value"};
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(UIImageWriteToSavedPhotosAlbum:didFinishSavingWithError:contextInfo:), (__bridge void *)(info));
    
    //    [self respondsToSelector:@selector(UIImageWriteToSavedPhotosAlbum:didFinishSavingWithError:contextInfo:), (__bridge void *)(info)]
    
    UIGraphicsBeginImageContext(CGSizeMake(200,400));
    //renderInContext呈现接受者及其子范围到指定的上下文
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    //返回一个基于当前图形上下文的图片
    UIImage *aImage =UIGraphicsGetImageFromCurrentImageContext();
    //移除栈顶的基于当前位图的图形上下文
    UIGraphicsEndImageContext();
    //以png格式返回指定图片的数据
    NSData *imageData =UIImagePNGRepresentation(aImage);
    NSLog(@"imageData.length=%d", imageData.length);
    
    
    
    CGPoint point = CGPointMake(10, 10);
    NSString *pointString = NSStringFromCGPoint(point);
    point = CGPointFromString(pointString);
    
    
    CGRect rect = CGRectMake(10, 10, 100, 100);
    NSString *rectString = NSStringFromCGRect(rect);
    rect = CGRectFromString(rectString);
    
}


- (void)UIImageWriteToSavedPhotosAlbum: (UIImage *) image
              didFinishSavingWithError: (NSError *) error
                           contextInfo: (void *) contextInfo{
    NSLog(@"error=%@ contextInfo=%@", error, (__bridge NSDictionary *)contextInfo);
}


@end
