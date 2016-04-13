//
//  ViewControllerUtil.h
//  TalkNic
//
//  Created by Lingyi on 16/3/15.
//  Copyright © 2016年 TalKNik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewControllerUtil : NSObject
-(UILabel *)SetTitle:(NSString *)titleStr;

-(UINavigationBar* )ConfigNavigationBar:(NSString*)titleStr NavController: (UINavigationController *)NavController NavBar: (UINavigationBar*)NavBar;

//设置聊天视图VoiceViewController tabbar上聊天通知小红点，设置app图标上的通知小红点
+ (void)setVoiceViewControllerBadgeAndAppIconBadge;

//显示聊天视图VoiceViewController tabbar上聊天通知小红点，设置app图标上的通知小红点
+ (void)showVoiceViewVCTabbarBadgeAndAppIconBadgeWithNumber:(int)badgeNumber;


//UserDefault
-(NSString*)GetUid;
-(NSString*)GetLinked:(NSString*)method;
-(NSString*)CheckRole;
-(BOOL)CheckFinishedInformation;

-(void)GetUserInformation:(NSString*)uid;
-(BOOL)IsValidChat:(NSString*) pay_time msg_time: (NSString*) msg_time;
-(void)RemainingMsgTimeNotify:(NSString*) pay_time msg_time: (NSString*) msg_time;

- (void)simplyShare:(NSUInteger) platform;
@end
