//
//  TestDebugVC.m
//
//  Created by junzhan on 15-7-29.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//

#import "TestDebugVC.h"
#import "wax.h"
@interface TestDebugVC ()
@property (nonatomic, strong) NSString *memberString;
@property (nonatomic, strong) NSDictionary *memberDict;
@end

@implementation TestDebugVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TestDebugVC" ofType:@"lua"];
        int i = wax_runLuaFile(path.UTF8String);
        if(i){
            NSLog(@"error=%s", lua_tostring(wax_currentLuaState(), -1));
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.memberString = @"abc";
    self.memberDict = @{@"k1":@"v1"};
}
- (IBAction)aButtonPress:(id)sender {
    NSLog(@"aButtonPress");
}

- (void)aAction:(NSString *)a{
    
}

- (void)bAction:(NSDictionary *)b{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
