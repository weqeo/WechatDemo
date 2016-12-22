//
//  WQXMPPTool.m
//  WechatDemo
//
//  Created by 魏强 on 16/12/19.
//  Copyright © 2016年 魏强. All rights reserved.
//

#import "WQXMPPTool.h"
@interface WQXMPPTool ()<XMPPStreamDelegate>{
//    XMPPStream *_xmppStream;
    XMPPResultBlock _resultBlock;
    XMPPReconnect *_reconnect;// 自动连接模块
    XMPPvCardCoreDataStorage *_vCardStorage;//电子名片的数据存储
    
    XMPPvCardAvatarModule *_avatar;//头像模块
    
    
    XMPPRoster *_roster;//花名册模块

}
// 1. 初始化XMPPStream
-(void)setupXMPPStream;


// 2.连接到服务器
-(void)connectToHost;

// 3.连接到服务成功后，再发送密码授权
-(void)sendPwdToHost;


// 4.授权成功后，发送"在线" 消息
-(void)sendOnlineToHost;

@end

@implementation WQXMPPTool
singleton_implementation(WQXMPPTool)


#pragma mark  -私有方法
#pragma mark 初始化XMPPStream
- (void)setupXMPPStream{
    _xmppStream = [[XMPPStream alloc]init];
    //添加自动连接模块
    _reconnect = [[XMPPReconnect alloc]init];
    [_reconnect activate:_xmppStream];
    
    //添加电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc]initWithvCardStorage:_vCardStorage];
    
    //激活
    [_vCard activate:_xmppStream];
    
    //添加头像模块
    _avatar = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_vCard];
    [_vCard activate:_xmppStream];
    
    //添加花名册模块[获取好友列表]
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc]init];
    _roster = [[XMPPRoster alloc]initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    
    //设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}

#pragma mark 释放xmppStream相关的资源
-(void)teardownXmpp{
    
    // 移除代理
    [_xmppStream removeDelegate:self];
    
    // 停止模块
    [_reconnect deactivate];
    [_vCard deactivate];
    [_avatar deactivate];
    [_roster deactivate];
    
    // 断开连接
    [_xmppStream disconnect];
    
    // 清空资源
    _reconnect = nil;
    _vCard = nil;
    _vCardStorage = nil;
    _avatar = nil;
    _roster = nil;
    _rosterStorage = nil;
    _xmppStream = nil;
    
}
- (void)connectToHost{
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    // 从单例获取用户名
    NSString *user = nil;
    if (self.isRegisterOperation) {
        user = [WQUserInfo sharedWQUserInfo].registerUser;
        
    }else{
        user = [WQUserInfo sharedWQUserInfo].user;
    }
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

#pragma mark 连接到服务成功后，再发送密码授权
-(void)sendPwdToHost{
    WQLog(@"再发送密码授权");
    NSError *err = nil;
    
    // 从单例里获取密码
    NSString *pwd = [WQUserInfo sharedWQUserInfo].pwd;
    
    [_xmppStream authenticateWithPassword:pwd error:&err];
    
    if (err) {
        WQLog(@"%@",err);
    }
}
#pragma mark  授权成功后，发送"在线" 消息
-(void)sendOnlineToHost{
    
    WQLog(@"发送 在线 消息");
    XMPPPresence *presence = [XMPPPresence presence];
    WQLog(@"%@",presence);
    
    [_xmppStream sendElement:presence];
    
    
}
#pragma mark -XMPPStream的代理
#pragma mark 与主机连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    WQLog(@"与主机连接成功");
    
    if (self.isRegisterOperation) {//注册操作，发送注册的密码
        NSString *pwd = [WQUserInfo sharedWQUserInfo].registerPwd;
        [_xmppStream registerWithPassword:pwd error:nil];
    }else{//登录操作
        // 主机连接成功后，发送密码进行授权
        [self sendPwdToHost];
    }
    
}
#pragma mark  与主机断开连接
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    // 如果有错误，代表连接失败
    
    // 如果没有错误，表示正常的断开连接(人为断开连接)
    
    
    if(error && _resultBlock){
        _resultBlock(XMPPResultTypeNetErr);
    }
    WQLog(@"与主机断开连接 %@",error);
    
}


#pragma mark 授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    WQLog(@"授权成功");
    
    [self sendOnlineToHost];
    
    // 回调控制器登录成功
    if(_resultBlock){
        _resultBlock(XMPPResultTypeLoginSuccess);
    }
    
    
}


#pragma mark 授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    WQLog(@"授权失败 %@",error);
    
    // 判断block有无值，再回调给登录控制器
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
}

#pragma mark 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    WQLog(@"注册成功");
    if(_resultBlock){
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
    
}

#pragma mark 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    
    WQLog(@"注册失败 %@",error);
    if(_resultBlock){
        _resultBlock(XMPPResultTypeRegisterFailure);
    }
    
}

#pragma mark -公共方法
- (void)xmppUserLogout{
   // 1." 发送 "离线" 消息"
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    //2.与服务器断开连接
    [_xmppStream disconnect];
    
    //3.回到登录界面
    [UIStoryboard showInitialVCWithName:@"Login"];
    
    //4.更新用户的登录状态
    [WQUserInfo sharedWQUserInfo].loginStatus = NO;
    [[WQUserInfo sharedWQUserInfo] saveUserInfoToSanbox];
    
}

-(void)xmppUserLogin:(XMPPResultBlock)resultBlock{
    
    // 先把block存起来
    _resultBlock = resultBlock;
    
    //    Domain=XMPPStreamErrorDomain Code=1 "Attempting to connect while already connected or connecting." UserInfo=0x7fd86bf06700 {NSLocalizedDescription=Attempting to connect while already connected or connecting.}
    // 如果以前连接过服务，要断开
    [_xmppStream disconnect];
    
    // 连接主机 成功后发送登录密码
    [self connectToHost];
}


-(void)xmppUserRegister:(XMPPResultBlock)resultBlock{
    // 先把block存起来
    _resultBlock = resultBlock;
    
    // 如果以前连接过服务，要断开
    [_xmppStream disconnect];
    
    // 连接主机 成功后发送注册密码
    [self connectToHost];
}

-(void)dealloc{
    [self teardownXmpp];
}
@end
