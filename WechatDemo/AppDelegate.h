//
//  AppDelegate.h
//  WechatDemo
//
//  Created by 魏强 on 16/12/12.
//  Copyright © 2016年 魏强. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败（账号、密码错误等原因）
    XMPPResultTypeNetworkErr//网络不给力
}XMPPResultType;
typedef void(^XMPPResultBlock)(XMPPResultType type);//XMPP登录请求结果的block
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)logOut;
- (void)login:(XMPPResultBlock)resultBlock;

@end

