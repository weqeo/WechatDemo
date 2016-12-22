//
//  WQContactAddController.m
//  WechatDemo
//
//  Created by 魏强 on 16/12/22.
//  Copyright © 2016年 魏强. All rights reserved.
//

#import "WQContactAddController.h"

@interface WQContactAddController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *contactTf;

@end

@implementation WQContactAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //添加好友
    //1.获取好友账号
    NSString *user = textField.text;
    WQLog(@"%@", user);
    //2.判断是否添加的自己
    if ([user isEqualToString:[WQUserInfo sharedWQUserInfo].user]) {
        [self showAlert:@"不能添加自己为好友"];
        return YES ;
    }
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@",user,domain];
    XMPPJID *friendJid = [XMPPJID jidWithString:jidStr];
    
    //3.判断好友是否已经存在
    if ([[WQXMPPTool sharedWQXMPPTool].rosterStorage userExistsWithJID:friendJid xmppStream:[WQXMPPTool sharedWQXMPPTool].xmppStream]) {
        [self showAlert:@"当前好友已经存在"];
        return YES ;
    }
    
    //4.发送好友添加的请求
    // 添加好友，xmpp有个叫订阅
    
    [[WQXMPPTool sharedWQXMPPTool].roster subscribePresenceToUser:friendJid];
    return  YES;
    
}
-(void)showAlert:(NSString *)msg{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"谢谢" otherButtonTitles:nil, nil];
    [alert show];
}
@end
