//
//  WQRegisgerViewController.h
//  WechatDemo
//
//  Created by 魏强 on 16/12/20.
//  Copyright © 2016年 魏强. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WQRegisgerViewControllerDelegate <NSObject>

/**
 *  完成注册
 */
-(void)regisgerViewControllerDidFinishRegister;

@end
@interface WQRegisgerViewController : UIViewController
@property (nonatomic, weak) id<WQRegisgerViewControllerDelegate> delegate;
@end
