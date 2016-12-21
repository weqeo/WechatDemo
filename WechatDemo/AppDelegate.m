//
//  AppDelegate.m
//  WechatDemo
//
//  Created by 魏强 on 16/12/12.
//  Copyright © 2016年 魏强. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "WQNavController.h"
/**
 *  在Appdelegate实现登陆
 
 1.初始化XMPPStream
 2.连接到服务器（传一个JID）
 3.连接到服务成功后，再发送密码授权
 4.授权成功后，发送在线消息
 */
@interface AppDelegate ()<XMPPStreamDelegate>{
    XMPPStream *_xmppStream;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   //沙盒的路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 打开XMPP的日志
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    WQLog(@"%@",path);
    // 设置导航栏背景
    [WQNavController setupNavTheme];
    [[WQUserInfo sharedWQUserInfo] loadUserInfoFromSanbox];
    // 判断用户的登录状态，YES 直接来到主界面
    if([WQUserInfo sharedWQUserInfo].loginStatus){
        UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = storayobard.instantiateInitialViewController;
        
        // 自动登录服务
        [[WQXMPPTool sharedWQXMPPTool] xmppUserLogin:nil];
    }
    
    return YES;
}



@end
