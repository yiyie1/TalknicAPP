//  AppDelegate+ShareSDk.m
//  CDL_optimize
//
//  Created by Talknic on 16/1/4.
//  Copyright © 2016年 Talknic. All rights reserved.
//


#import "AppDelegate+ShareSDk.h"
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import "WXApi.h"
#import "WeiboSDK.h"
#import <ShareSDKConnector/ShareSDKConnector.h>


//新浪微博
#define kSinaWeiboAPPKey @"4204340314"
#define kSinaWeiboAPPSecret @"f9debe4609a443b59563c91e930461d2"

//腾讯微博
#define kTencentWeiboAPPKey @"*********"
#define kTencentWeiboAPPSecret @"**********"

//QQ
#define kQQAPPId @"**********"
#define kQQAPPKey @"**********"

//微信
#define kWechatAPPId @"wx8b3ca34d86a11657"
#define kWechatAPPSecret @"66ede60b4c0a25eeabf2b4a59090217d"




@implementation AppDelegate (ShareSDk)

- (void)addShareSDKWithapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //初始化配置
    [self shareInit];
    
    
    
}

#pragma mark 分享平台初始化
- (void)shareInit
{
    NSArray *platformArray = [NSArray array];
    
    platformArray = @[@(SSDKPlatformTypeSinaWeibo),
//                      @(SSDKPlatformTypeTencentWeibo),
                      @(SSDKPlatformTypeWechat),
//                      @(SSDKPlatformTypeQQ),
                      ];
    
    
    /**
     *  构造分享平台
     *
     *  @param platformType 分享平台
     *
     *  @param onImport 此时如果要分享到一些客户端这个block块必须要填。
     *
     *  @param onConfiguration appkey的相关配置
     */
    [ShareSDK registerApp:AppShareSDKKey activePlatforms:platformArray
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                             
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              
              
              switch(platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息，其中authType设置为使用SSO+web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:kSinaWeiboAPPKey appSecret:kSinaWeiboAPPSecret redirectUri:@"http://www.talknic.cn" authType:SSDKAuthTypeBoth];
                      break;
                      
//                  case SSDKPlatformTypeTencentWeibo:
//                      //设置腾讯微博应用信息，其中authType只能使用web形式授权
//                      [appInfo SSDKSetupTencentWeiboByAppKey:kTencentWeiboAPPKey appSecret:kTencentWeiboAPPSecret redirectUri:@"http://www.sharesdk.cn"];
//                      break;
//                      
//                  case SSDKPlatformTypeQQ:
//                      //QQ平台
//                      [appInfo SSDKSetupQQByAppId:kQQAPPId appKey:kQQAPPKey authType:SSDKAuthTypeBoth];
//                      break;
                      case SSDKPlatformTypeSMS:
                      break;
//
                  case SSDKPlatformTypeWechat:
                      //微信平台
                      [appInfo SSDKSetupWeChatByAppId:kWechatAPPId appSecret:kWechatAPPSecret];
                      break;
                      
                      default:
                      break;
                      
              }
              
          }];
    
}


- (void)platShareView:(UIView *)view WithShareContent:(NSString *)shareContent WithShareUrlImg:(NSString *)shareUrlImg WithShareTitle:(NSString *)shareTitle WithShareUrl:(NSString *)shareUrl WithShareType:(kShareType)shareType
{
//    NSString *shareUrl = nil;
//    if(shareType == shareInfo){
    
//        shareUrl = kInfoShareRequest(shareId);根据分享类型设定你要分享的链接
        
//    }else{
    
//        shareUrl = kDartBarShareRequest(shareId);
//    }
    
    
    
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
#pragma mark 公共分享参数
    //    [shareParams SSDKSetupShareParamsByText:@"分享内容"
    //                                     images:imageArray
    //                                        url:[NSURL URLWithString:@"http://mob.com"]
    //                                      title:@"分享标题"
    //                                       type:SSDKContentTypeImage];
    
#pragma mark 平台定制分享参数
    UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareUrlImg]]];
    
    //微信好友
    
    [shareParams SSDKSetupWeChatParamsByText:nil title:shareTitle url:[NSURL URLWithString:shareUrl] thumbImage:shareImg image:shareImg musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    //微信朋友圈
    [shareParams SSDKSetupWeChatParamsByText:nil title:shareTitle url:[NSURL URLWithString:shareUrl] thumbImage:shareImg image:shareImg musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    //新浪微博
   [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@",shareContent] title:shareTitle image:shareImg url:nil latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    //短信
    [shareParams SSDKSetupSMSParamsByText:nil title:shareTitle images:nil attachments:nil recipients:nil type:(SSDKContentTypeText)];
    
//    //腾讯微博
//    [shareParams SSDKSetupTencentWeiboShareParamsByText:[NSString stringWithFormat:@"%@ %@",shareContent,shareUrl] images:shareImg latitude:0 longitude:0 type:SSDKContentTypeText];
//    
//    //QQ空间
//    [shareParams SSDKSetupQQParamsByText:nil title:shareTitle url:[NSURL URLWithString:shareUrl] thumbImage:shareImg image:shareImg type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQZone];
//    
//    //QQ好友
//    [shareParams SSDKSetupQQParamsByText:nil title:shareTitle url:[NSURL URLWithString:shareUrl] thumbImage:shareImg image:shareImg type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
//    
    //微信收藏
    [shareParams SSDKSetupWeChatParamsByText:nil title:shareTitle url:[NSURL URLWithString:shareUrl] thumbImage:shareImg image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:shareImg type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatFav];
    
    
    
#pragma mark  不跳过编辑界面的分享框
        [ShareSDK showShareActionSheet:view items:[ShareSDK activePlatforms] shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
    
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kAlertShare
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:kAlertSure
                                                              otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kAlertFail
                                                                        message:[NSString stringWithFormat:@"%@", error]
                                                                       delegate:nil
                                                              cancelButtonTitle:kAlertSure
                                                              otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateCancel:
                {
                    break;
                }
                default:
                    break;
            }
        }];
    
    
#pragma mark 设置跳过分享编辑页面，直接分享的平台。
//    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:view items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//        
//        switch (state)
//        {
//            case SSDKResponseStateSuccess:
//            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alertView show];
//                break;
//            }
//            case SSDKResponseStateFail:
//            {
//                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"分享失败"
//                                                                   message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
//                [alertView show];
//                break;
//            }
//            case SSDKResponseStateCancel:
//            {
//                
//                break;
//            }
//            default:
//                break;
//        }
//        
////        [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
//    }];
    
    //删除和添加平台示例
//    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
//    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeWechat)];
    
    
}







@end