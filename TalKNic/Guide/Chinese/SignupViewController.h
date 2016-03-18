//
//  SignupViewController.h
//  TalkNic
//
//  Created by Talknic on 15/10/9.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginViewController;

@interface SignupViewController : UIViewController
@property BOOL mobile;
@property (nonatomic,strong)LoginViewController *loginVC;
@end
