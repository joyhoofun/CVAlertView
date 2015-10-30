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
    _alertView = [[CVAlertView alloc] initWithTitle:@"早间新闻" message:@"新华网北京10月29日电（记者刘华）国家主席习近平29日在钓鱼台国宾馆会见德国总理默克尔。双方积极评价中德关系发展，同意进一步加强两国各领域务实合作，保持中德全方位战略伙伴关系健康、稳定、持续向前发展。习近平欢迎默克尔担任总理以来第八次访华，指出中德两国领导人保持密切交往体现了两国关系的高水平发展。中德关系关乎两国人民福祉，也关乎中欧合作乃至世界经济发展。两国发展全方位战略伙伴关系，既要立足双边，也要放眼中欧、亚欧乃至全球双方要巩固政治互信，尊重彼此发展道路，理解和照顾彼此核心利益和重大关切，保持各层次密切交往势头。《中德合作行动纲要》已经产生积极成效。双方要进一步挖掘合作潜力，培育更多合作增长点，推动财政金融、城镇化、农业、电动汽车、节能环保、智能制造和生产网络化等领域合作不断取得新进展。中方欢迎德方参与中国中西部地区发展和东北老工业基地改造，欢迎德国担任2016年中国西部博览会主宾国。中德在文化、教育、体育、医疗卫生、社会保障、残疾人事业等众多领域合作空间广阔。中方支持双方明年共同举办中德青少年交流年。" cancelButtonTitle:@"取消" otherButtonTitle:@"设置" otherButtonAction:^{
        NSLog(@"点击确认");
    }];
    [_alertView setCloseWhenTocuh:NO];
//    _alertView = [[CVAlertView alloc] initWithTitle:nil message:@"您已关闭CVTalk通知，请在\"设置\"-\"通知\"-\"CVTalk\"中打开" cancelButtonTitle:@"取消" otherButtonTitle:@"设置" otherButtonAction:^{
//        NSLog(@"点击确认");
//    }];
    
   // _alertView = [[CVAlertView alloc] initWithTitle:@"版本1.2中的新功能" message:@"1.支持iOS9 \n 2.增加丰富的表情 \n 3.peter改进了很多bug" cancelButtonTitle:@"确认" otherButtonTitle:nil otherButtonAction:nil];
    
    
    
//    _alertView = [[CVAlertView alloc] initWithTitle:@"通知" message:@"各位朋友你们好，现在通报批评如下：嗯嗯嗯" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认",@"回退"] otherButtonActions:@[^{NSLog(@"按第一个");},^{NSLog(@"按第二个");}]];
    
    [_alertView showAlertView];
   // [self tapButton2];
}

- (void)tapButton2 {
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"版本1.2中的新功能" message:@"1.支持iOS9 \n 2.增加丰富的表情 \n 3.peter改进了很多bug" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil,nil];
    [view show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
