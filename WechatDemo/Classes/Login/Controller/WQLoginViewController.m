//
//  WQLoginViewController.m
//  WechatDemo
//
//  Created by 魏强 on 16/12/20.
//  Copyright © 2016年 魏强. All rights reserved.
//

#import "WQLoginViewController.h"
#import "WQRegisgerViewController.h"
#import "WQNavController.h"
@interface WQLoginViewController ()<WQRegisgerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation WQLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置TextField和Btn的样式
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    
    [self.pwdField addLeftViewWithImage:@"Card_Lock"];
    
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    
    // 设置用户名为上次登录的用户名
    
    //从沙盒获取用户名
    NSString *user = [WQUserInfo sharedWQUserInfo].user;
    self.userLabel.text = user;

}

- (IBAction)loginBtnClick:(id)sender {
    
    // 保存数据到单例
    
    WQUserInfo *userInfo = [WQUserInfo sharedWQUserInfo];
    userInfo.user = self.userLabel.text;
    userInfo.pwd = self.pwdField.text;
    
    // 调用父类的登录
    [super login];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // 获取注册控制器
    id destVc = segue.destinationViewController;
    
    
    if ([destVc isKindOfClass:[WQNavController class]]) {
        WQNavController *nav = destVc;
        //获取根控制器
        
        if ([nav.topViewController isKindOfClass:[WQRegisgerViewController class]]) {
            WQRegisgerViewController *registerVc =  (WQRegisgerViewController *)nav.topViewController;
            // 设置注册控制器的代理
            registerVc.delegate = self;
        }
        
    }
    
}

#pragma mark regisgerViewController的代理
-(void)regisgerViewControllerDidFinishRegister{
    WQLog(@"完成注册");
    // 完成注册 userLabel显示注册的用户名
    self.userLabel.text = [WQUserInfo sharedWQUserInfo].registerUser;
    
    // 提示
    [MBProgressHUD showSuccess:@"请重新输入密码进行登录" toView:self.view];
    
    
}

@end
