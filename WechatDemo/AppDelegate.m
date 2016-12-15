//
//  AppDelegate.m
//  WechatDemo
//
//  Created by 魏强 on 16/12/12.
//  Copyright © 2016年 魏强. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
/**
 *  在Appdelegate实现登陆
 
 1.初始化XMPPStream
 2.连接到服务器（传一个JID）
 3.连接到服务成功后，再发送密码授权
 4.授权成功后，发送在线消息
 */
@interface AppDelegate ()<XMPPStreamDelegate>{
    XMPPStream *_xmppStream;
    XMPPResultBlock _resultBlock;
}
/***  1.初始化XMPPStream */
- (void)setupXMPPStream;
/***  2.连接到服务器（传一个JID）*/
- (void)connectToHost;
/***   3.连接到服务成功后，再发送密码授权 */
- (void)sendPwdToHost;
/***  4.授权成功后，发送在线消息 */
- (void)sendOnlineToHost;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

#pragma mark - 私有方法
- (void)setupXMPPStream{
    _xmppStream = [[XMPPStream alloc]init];
    
    //设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}
- (void)login:(XMPPResultBlock)resultBlock{
    _resultBlock = resultBlock;
    // 如果以前连接过服务，要断开
    [_xmppStream disconnect];
    //连接主机
    [self connectToHost];
}
- (void)connectToHost{
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    NSUserDefaults *usd = [NSUserDefaults standardUserDefaults];
    NSString *user = [usd objectForKey:@"user"];
    //设置登录用户的JID
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:@"weqeodeimac.local" resource:@"iphone"];
    _xmppStream.myJID = myJID;
    _xmppStream.hostName = @"192.168.1.19";//可以是域名，也可以是ip地址
    //    _xmppStream.hostPort = 5222; 默认就是5222，如果服务器的端口没变的话，可以省略。
    NSError *err = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]) {
        WQLog(@"%@",err);
    };
    
}
- (void)sendPwdToHost{
    NSError *err = nil;
    NSUserDefaults *usd = [NSUserDefaults standardUserDefaults];
    NSString *pwd = [usd objectForKey:@"pwd"];
    [_xmppStream authenticateWithPassword:pwd error:&err];
    if (err) {
        WQLog(@"%@",err);
    }
}
- (void)sendOnlineToHost{
    XMPPPresence *presence = [XMPPPresence presence];
    WQLog(@"%@", presence);
    [_xmppStream sendElement:presence];
}
#pragma mark - XMPPStreamDelegate

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    WQLog(@"与主机连接成功！");
    
    //主机连接成功之后，发送密码进行授权
    [self sendPwdToHost];
}

-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    //    if (error) {
    WQLog(@"与主机断开连接 %@", error);
    //    }
    if (error && _resultBlock) {
        _resultBlock(XMPPResultTypeNetworkErr);
    }
}
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    WQLog(@"授权成功！");
    
    ////授权成功之后，发送在线消息给服务器
    [self sendOnlineToHost];
    
    _resultBlock(XMPPResultTypeLoginSuccess);

    
}
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    WQLog(@"授权失败！%@", error);
    _resultBlock(XMPPResultTypeLoginFailure);
}

#pragma mark -公共方法
- (void)logOut{
    //1.发送“离线”消息
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    //2.与服务器断开连接
    [_xmppStream disconnect];
    
}

@end
