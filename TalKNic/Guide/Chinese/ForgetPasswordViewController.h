//
//  ForgetPasswordViewController.h
//  TalkNic
//
//  Created by Talknic on 15/10/19.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginViewController;

@interface ForgetPasswordViewController : UIViewController
@property (nonatomic,strong)NSString *telMailNum;
@property BOOL mobile;//是否是手机登陆
@property (nonatomic,strong)LoginViewController *loginVC;
@end
