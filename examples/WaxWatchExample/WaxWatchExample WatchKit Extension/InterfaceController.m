//
//  InterfaceController.m
//  WaxWatchExample WatchKit Extension
//
//  Created by junzhan on 15/10/28.
//  Copyright © 2015年 test.jz.com. All rights reserved.
//

#import "InterfaceController.h"

#import "wax.h"
#import "lua.h"
@interface InterfaceController()
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *helloLabel;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



