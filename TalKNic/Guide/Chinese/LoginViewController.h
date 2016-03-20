//
//  LoginViewController.h
//  TalkNic
//
//  Created by Talknic on 15/10/9.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (copy,nonatomic)NSString *uid;
@property (nonatomic,strong)NSString *telNum;
@property (nonatomic,copy)NSString *identity;
@property (nonatomic,strong)UITextField *loginmobileTF;
@property (nonatomic,strong)UITextField *passwordTF;
@property BOOL mobile;//是否是手机登陆
@end
