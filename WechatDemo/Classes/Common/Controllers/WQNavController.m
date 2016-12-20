//
//  WQNavController.m
//  WechatDemo
//
//  Created by 魏强 on 16/12/19.
//  Copyright © 2016年 魏强. All rights reserved.
//

#import "WQNavController.h"

@interface WQNavController ()

@end

@implementation WQNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
+ (void)setupNavTheme{
    //设置导航样式
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    //1.设置导航条的背景
    // 高度不会拉伸，但是宽度会拉伸
    [navBar setBackgroundImage:[UIImage imageNamed:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];
    
    // 2.设置栏的字体
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSForegroundColorAttributeName] = [UIColor whiteColor];
    att[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    
    [navBar setTitleTextAttributes:att];
    
    // 设置状态栏的样式
    // xcode5以上，创建的项目，默认的话，这个状态栏的样式由控制器决定
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
