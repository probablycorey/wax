//
//  ViewController.m
//  BlockExample
//
//  Created by junzhan on 15/12/29.
//  Copyright © 2015年 test.jz.com. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
@interface ViewController ()
{
    NSInteger _aInteger;
    CGFloat _aCGFloat;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _aInteger = 1234;
    _aCGFloat = 456;
    [self setMyView];
    NSLog(@"_aInteger=%ld _aCGFloat=%f", (long)_aInteger, _aCGFloat);
}

- (void)setMyView {
    UIView *view = [UIView new];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor greenColor];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.offset(50);
        make.height.offset(50);
    }];
}


- (void)setMyView2
{
    UIView *view = [UIView new];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor greenColor];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(200);
        make.left.equalTo(self.view).offset(50);
        make.width.offset(10);
        make.height.offset(10);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
