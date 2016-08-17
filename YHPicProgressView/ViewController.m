//
//  ViewController.m
//  YHPicProgressView
//
//  Created by zhouxf on 16/8/17.
//  Copyright © 2016年 busap. All rights reserved.
//

#import "ViewController.h"
#import "YHPicProgressView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YHPicProgressView *ppv = [[YHPicProgressView alloc] init];
    ppv.backgroundColor = [UIColor blueColor];
    [self.view addSubview:ppv];
    ppv.frame = CGRectMake(20, 80, 220, 250);
    ppv.progress = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
