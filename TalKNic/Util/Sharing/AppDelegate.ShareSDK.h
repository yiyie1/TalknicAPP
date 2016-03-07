//
//  AppDelegate+ShareSDK.h
//  MyShare
//
//  Created by ldy on 16/1/4.
//  Copyright © 2016年 ldy. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>

//下面这个枚举用来判断分享哪个模块，建议放在pch文件中
typedef enum
{
    shareDartbar,
    shareInfo,   //资讯分享

}kShareType;

@interface AppDelegate (ShareSDK)
// shareSDK分享
- (void)addShareSDKWithapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

//定制平台分享内容分享
- (void)platShareView:(UIView *)view WithShareContent:(NSString *)shareContent WithShareUrlImg:(NSString *)shareUrlImg WithShareTitle:(NSString *)shareTitle WithShareUrl:(NSString *)shareUrl WithShareType:(kShareType)shareType;

@end
