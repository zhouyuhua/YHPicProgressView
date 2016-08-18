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
    
    YHPicProgressView *ppv1 = [[YHPicProgressView alloc] init];
    ppv1.backgroundColor = [UIColor redColor];
    [self.view addSubview:ppv1];
    ppv1.frame = CGRectMake(240, 80, 22, 25);
    ppv1.progress = 1;
    
    YHPicProgressView *ppv2 = [[YHPicProgressView alloc] init];
    ppv2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:ppv2];
    ppv2.frame = CGRectMake(240, 105, 44, 50);
    ppv2.progress = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
