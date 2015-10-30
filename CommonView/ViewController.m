//
//  ViewController.m
//  CommonView
//
//  Created by Jadenhu on 15/10/28.
//  Copyright © 2015年 CVTE. All rights reserved.
//

#import "ViewController.h"
#import "CVAlertView.h"

@interface ViewController ()

@property (nonatomic,strong) CVAlertView *alertView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    [button setTitle:@"弹出框" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(tapButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 100, 100)];
    [button1 setTitle:@"弹出系统框" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(tapButton2) forControlEvents:UIControlEventTouchUpInside];
}
- (void)tapButton {
    CVAlertView *alertView = [[CVAlertView alloc] initWithTitle:@"新功能" message:@"1.支持iOS9 \n 2.增加丰富的表情 \n 3.peter 改进了很多bug" cancelButtonTitle:@"确认" otherButtonTitle:nil otherButtonAction:nil];
    [alertView showAlertView];
}

- (void)tapButton2 {
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"版本1.2中的新功能" message:@"1.支持iOS9 \n 2.增加丰富的表情 \n 3.peter改进了很多bug" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil,nil];
    [view show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
