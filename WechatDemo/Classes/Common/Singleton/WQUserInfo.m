//
//  WQUserInfo.m
//  WechatDemo
//
//  Created by 魏强 on 16/12/19.
//  Copyright © 2016年 魏强. All rights reserved.
//

#import "WQUserInfo.h"
#define UserKey @"user"
#define LoginStatusKey @"LoginStatus"
#define PwdKey @"pwd"

@implementation WQUserInfo
singleton_implementation(WQUserInfo)
- (void)saveUserInfoToSanbox{
    NSUserDefaults *dft = [NSUserDefaults standardUserDefaults];
    [dft setObject:self.user forKey:UserKey];
    [dft setBool:self.loginStatus forKey:LoginStatusKey];
    [dft setObject:self.pwd forKey:PwdKey];
    [dft synchronize];
}
-(void)loadUserInfoFromSanbox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.user = [defaults objectForKey:UserKey];
    self.loginStatus = [defaults boolForKey:LoginStatusKey];
    self.pwd = [defaults objectForKey:PwdKey];
}
-(NSString *)jid{
    return [NSString stringWithFormat:@"%@@%@",self.user,domain];
}
@end
