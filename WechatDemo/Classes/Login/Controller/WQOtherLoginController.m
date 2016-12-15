//
//  WQOtherLoginController.m
//  WechatDemo
//
//  Created by 魏强 on 16/12/13.
//  Copyright © 2016年 魏强. All rights reserved.
//

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
    NSString *user = self.userTf.text;
    NSString *pwd = self.pwdTf.text;
    [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"user"];
    [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:@"pwd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    AppDelegate *app =  [UIApplication sharedApplication].delegate;
    [MBProgressHUD showMessage:@"正在登录……"];
    __weak typeof (self) selfVc = self;
    [app login:^(XMPPResultType type) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            switch (type) {
                case XMPPResultTypeLoginSuccess:{
                    [self dismissViewControllerAnimated:YES completion:nil];
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    selfVc.view.window.rootViewController = sb.instantiateInitialViewController;
                    break;
                }
                case XMPPResultTypeLoginFailure:
                    [MBProgressHUD showError:@"账号或密码错误！"];
//                }
                    break;
                case XMPPResultTypeNetworkErr:
                    [MBProgressHUD showError:@"网络不给力！"];
                    break;
                default:
                    break;
            }
        });
        
    }];
    
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
