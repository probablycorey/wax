//
//  ViewController.m
//  LuaCodeDebug
//
//  Created by junzhan on 15/10/15.
//  Copyright © 2015年 test.jz.com. All rights reserved.
//

#import "ViewController.h"
#import "TestDebugVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 200, 44)];
    [button setTitle:@"TestLuaDebug" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(testLuaDebugButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
}
- (void)testLuaDebugButtonPressed:(id)sender {
    TestDebugVC *vc = [[TestDebugVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
