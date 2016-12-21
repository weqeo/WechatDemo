//
//  WQOtherLoginController.m
//  WechatDemo
//
//  Created by 魏强 on 16/12/13.
//  Copyright © 2016年 魏强. All rights reserved.
//  /Users/MarkWei/Library/Developer/Xcode/UserData/CodeSnippets

#import "WQOtherLoginController.h"
#import "AppDelegate.h"
@interface WQOtherLoginController ()<UITextFieldDelegate>
/**  containView距离左边的距离约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containView_cons_left;
/**  containView距离右边的距离约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containView_cons_right;
/**  用户输入tf */
@property (weak, nonatomic) IBOutlet UITextField *userTf;
/**  密码输入tf */
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;

@end

@implementation WQOtherLoginController
#pragma mark - 懒加载区

#pragma mark - 生命周期区
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"其它方式登录";
    // 判断当前设备的类型，改变左右两边约束的距离
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.containView_cons_left.constant = 10;
        self.containView_cons_right.constant = 10;
    }
}
#pragma mark - 板块布置区

#pragma mark - 事件点击区
- (IBAction)LoginBtnClick:(UIButton *)sender {
    /**
     *  1.把用户名和密码放在沙盒
        2.调用AppDelegate的一个connect连接服务并登录
     */
    // 登录
    
    /*
     * 官方的登录实现
     
     * 1.把用户名和密码放在WCUserInfo的单例
     
     
     * 2.调用 AppDelegate的一个login 连接服务并登录
     */
    
    WQUserInfo *userInfo = [WQUserInfo sharedWQUserInfo];
    userInfo.user = self.userTf.text;
    userInfo.pwd = self.pwdTf.text;
    
    [super login];
    
}
- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 网络请求区

#pragma mark - 通知接收区


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)dealloc{
    WQLog(@"%s", __func__);
}

@end
