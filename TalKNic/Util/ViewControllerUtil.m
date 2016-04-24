//
//  ViewControllerUtil.m
//  TalkNic
//
//  Created by Lingyi on 16/3/15.
//  Copyright © 2016年 TalKNik. All rights reserved.
//

#import "ViewControllerUtil.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "solveJsonData.h"
#import "TalkTabBarViewController.h"
#include "TalkNavigationController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

@interface ViewControllerUtil () <UIAlertViewDelegate>

@end
@implementation ViewControllerUtil

+(UILabel *)SetTitle:(NSString *)titleStr
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = titleStr;
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17.0];
    
    return title;
}

+(BOOL)IsValidChat:(NSString*) pay_time msg_time: (NSString*) msg_time
{
    NSDate *dateNow = [NSDate date];
    NSTimeInterval sec1970 = [dateNow timeIntervalSince1970];
    
    NSTimeInterval time_after_pay = sec1970 - [pay_time doubleValue];
    TalkLog(@"time_after_pay: %f hours", time_after_pay / 60 / 60);

    return time_after_pay < DEFAULT_MAX_CHAT_DURATION_MINS * 60 && ![msg_time isEqualToString:@"0"];
}

+(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
}

+(void)RemainingMsgTimeNotify:(NSString*) pay_time msg_time: (NSString*) msg_time
{
    NSDate *dateNow = [NSDate date];
    NSTimeInterval sec1970 = [dateNow timeIntervalSince1970];
    
    NSTimeInterval time_after_pay = sec1970 - [pay_time doubleValue];
    TalkLog(@"time_after_pay: %f hours", time_after_pay / 60 / 60);
    
    if((DEFAULT_MAX_CHAT_DURATION_MINS * 60 - time_after_pay) < ([msg_time integerValue] + 60))
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:AppNotify message:AppTotalTimeLessThanMsgTime delegate:self cancelButtonTitle:AppSure otherButtonTitles:@"Pay", nil];
        [alert show];

    }

    if ([msg_time integerValue] < 60)
    {
        [MBProgressHUD showSuccess:kAlertOneMinute];
    }
}

+(UINavigationBar* )ConfigNavigationBar:(NSString*)titleStr NavController: (UINavigationController *)NavController NavBar: (UINavigationBar*)NavBar
{
    [NavController setNavigationBarHidden:YES];
    if (NavBar == nil) {
        NavBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, kWidth, 129.0/2)];
        UIImage * img= [UIImage imageNamed:@"nav_bg.png"];
        img = [img stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        
        [NavBar setBackgroundImage:img forBarMetrics:(UIBarMetricsDefault)];
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, KHeightScaled(10), kWidth, 129.0/2);//NavBar.frame;
        label.text = titleStr;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17.0];
        
        [NavBar addSubview:label];
        //[self.view addSubview:_bar];
    }
    return NavBar;
}

+(NSString*)CheckRole
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:kChooese_ChineseOrForeigner] isEqualToString:@"Chinese"])
        return CHINESEUSER;
    else
        return FOREINERUSER;
}

+(NSString*)GetUid
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
}

+(NSString*)GetLinked:(NSString*)method
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:method];
}

+(BOOL)CheckFinishedInformation
{
    return ([[[NSUserDefaults standardUserDefaults] objectForKey:@"FinishedInformation"] isEqualToString:@"Done"]);
}

+(void)GetUserInformation:(NSString*)uid
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *parme = [NSMutableDictionary dictionary];
    parme[@"cmd"] = @"19";
    parme[@"user_id"] = uid;
    TalkLog(@"Me ID -- %@",uid);
    [session POST:PATH_GET_LOGIN parameters:parme progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TalkLog(@"Me result: %@",responseObject);
        NSDictionary* dic = [solveJsonData changeType:responseObject];
        if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2))
        {
            NSDictionary *dict = [dic objectForKey:@"result"];
            NSString* bSina = [dict objectForKey:@"sina"];
            if(bSina.length != 0)
                [[NSUserDefaults standardUserDefaults]setObject:bSina forKey:@"Weibo"];
            
            NSString* bWechat = [dict objectForKey:@"wechat"];
            if(bWechat.length != 0)
                [[NSUserDefaults standardUserDefaults]setObject:bWechat forKey:@"Wechat"];
            
            NSString* bEmail = [dict objectForKey:@"email"];
            if(bEmail.length != 0)
                [[NSUserDefaults standardUserDefaults]setObject:bEmail forKey:@"Email"];
            
            NSString* bMobile = [dict objectForKey:@"mobile"];
            if(bMobile.length != 0)
                [[NSUserDefaults standardUserDefaults]setObject:bMobile forKey:@"Mobile"];
            
        }
        else if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 4))
        {
            [MBProgressHUD showError:kAlertIDwrong];
            return;
        }
        else if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 3))
        {
            [MBProgressHUD showError:kAlertdataFailure];
            return;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];
}


/**
 *  // 统计环信未读消息个数,并显示小红点
 */
+ (void)setVoiceViewControllerBadgeAndAppIconBadge{

    NSDictionary *easeMobMessageCountsDic = [[NSUserDefaults standardUserDefaults] objectForKey:EaseMobUnreaderMessageCount];
    
    if (easeMobMessageCountsDic == nil) return;
    
    int allCount = 0;
    for(NSString *senderIdStr in easeMobMessageCountsDic.allKeys){
        NSString *senderCount = (NSString *)easeMobMessageCountsDic[senderIdStr];
        allCount += senderCount.intValue;
    }
    
    [self showVoiceViewVCTabbarBadgeAndAppIconBadgeWithNumber:allCount];
    
}



/**
 *  设置聊天视图VoiceViewController tabbar上通知小红点，设置app图标上的通知小红点
 *
 *  @param badgeNumber    小红点个数
 */
+ (void)showVoiceViewVCTabbarBadgeAndAppIconBadgeWithNumber:(int)badgeNumber{
    
    if (badgeNumber >= 0) {
        
        // 设置VoiceViewController的badgeNumber
        TalkNavigationController *talkNav = [self getVoiceViewController];
        talkNav.tabBarItem.badgeValue = badgeNumber == 0 ? nil : [NSString stringWithFormat:@"%d", badgeNumber];
        
        // 设置app图标小红点通知
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
    }

}

/**
 *  获取到VoiceViewController视图
 */
+ (TalkNavigationController *)getVoiceViewController{
    
    TalkTabBarViewController *talkTabbarVC = nil;
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
        talkTabbarVC = (TalkTabBarViewController *)topVC;
    }
    
    
    if ([[UIApplication sharedApplication].keyWindow.rootViewController class] == [TalkTabBarViewController class] &&
        [UIApplication sharedApplication].keyWindow.rootViewController != nil) {
        talkTabbarVC = (TalkTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        
    }
    
    if (talkTabbarVC.viewControllers.count > 1) {
        TalkNavigationController *talkNavVC = talkTabbarVC.viewControllers[1];
        return talkNavVC;
    }
    return nil;
}


/**
 *  简单分享
 */
+(void)simplyShare:(NSUInteger) platform
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    //__weak ViewController *theController = self;
    //[self showLoadingView:YES];
    
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSArray* imageArray = @[[UIImage imageNamed:@"sharing.jpg"]];
    
    if (imageArray) {
        
        [shareParams SSDKSetupShareParamsByText:@"Enjoy your Talknic"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://talknic.cn"]
                                          title:@"Talknic"
                                           type:SSDKContentTypeImage];
        
        //进行分享
        [ShareSDK share:platform//SSDKPlatformTypeSinaWeibo
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             
             //[theController showLoadingView:NO];
             //[theController.tableView reloadData];
             
             switch (state) {
                 case SSDKResponseStateSuccess:
                 {
                     [MBProgressHUD showSuccess:kAlertSharingSuccess];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     [MBProgressHUD showError:kAlertSharingFail];
                     break;
                 }
                 case SSDKResponseStateCancel:
                 {
                     [MBProgressHUD showError:kAlertSharingCancel];
                     break;
                 }
                 default:
                     break;
             }
         }];
    }
}

+(void)showNetworkErrorMessage:(NSError * _Nonnull) error
{
    NSLog(@"Sever error %@",error);
    [MBProgressHUD showError:kAlertNetworkError];
}

@end
