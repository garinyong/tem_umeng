//
//  ViewController.m
//  pp_new
//
//  Created by GaoYong on 15/2/27.
//  Copyright (c) 2015年 GaoYong. All rights reserved.
//

#import "ViewController.h"
#import "UMFeedback.h"
#import "FeedBackVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn  =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.frame = CGRectMake(self.view.bounds.size.width/2 - 50, self.view.bounds.size.height/2 - 40 ,100, 80);
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitle:@"feedback" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void) btnClick
{
//    [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
    FeedBackVC *vc = [FeedBackVC new];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
