//
//  AppDelegate.m
//  TalkNic
//
//  Created by Talknic on 15/10/9.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//
#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate.h"
#import "ChoosePeopleViewController.h"
#import "TalkTabBarViewController.h"
#import "SignupViewController.h"
#import "RootViewController.h"
#import "MeViewController.h"
#import "AppDelegate+ShareSDK.h"
#import "EaseMobSDK.h"
#import "UIImage+HKExtension.h"
#import "Foreigner1ViewController.h"
#import "Information1ViewController.h"
#import "ViewControllerUtil.h"
#import "HomeViewController.h"
#import "DailysettingViewController.h"
#import "MBProgressHUD+MJ.h"
#import "VoiceViewController.h"
#import "TalkNavigationController.h"
#import "CommonHeader.h"
#import "EaseMessageViewController.h"

@interface AppDelegate ()<EMChatManagerDelegate>

@end

extern NSString *CurrentTalkerUid; //记录当前聊天对象的uid，只有聊天界面打开时该变量才会被赋值

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    //集成分享登陆功能
    [self addShareSDKWithapplication:application didFinishLaunchingWithOptions:launchOptions];

    //注册远程推送消息监听
    [self registerRemoteNotification];
    
    
#warning 环信SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"TalknicDevelopmentApns";
#else
    apnsCertName = @"TalknicApns";
#endif

    //环信注册
    [EaseMobSDK easeMobRegisterSDKWithAppKey:kEaseKey apnsCertName:apnsCertName application:application didFinishLaunchingWithOptions:launchOptions];
    
    ViewControllerUtil *vcUtil = [[ViewControllerUtil alloc]init];
    
    NSString *role = [vcUtil CheckRole];
    NSString *uid = [vcUtil GetUid];
    TalkLog(@"uid: %@, role: %@", uid, role);
    TalkLog(@"Server Address: %@", PATH_GET_CODE);

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"UseApp"])
    {
        ChoosePeopleViewController *chooseVC = [[ChoosePeopleViewController alloc]init];
        UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:chooseVC];
        self.window.rootViewController = naVC;
    }
    else
    {
            TalkTabBarViewController *talkVC = [[TalkTabBarViewController alloc]init];
            talkVC.uid = uid;
            talkVC.identity = role;

            if ([role isEqualToString:CHINESEUSER])
            {
                if (uid.length == 0)
                {
                    [MBProgressHUD showError: kAlertNotLogin];
                }
                else
                {
                    HomeViewController *home = [[HomeViewController alloc]init];
                    home.uid = uid;
                    
                    //环信聊天登录，增加自动登录功能
                    [self loginHuanxinWithUid:uid];
                    
                }
            }
            else
            {
                if (uid.length == 0)
                {
                    [MBProgressHUD showError: kAlertNotLogin];
                }
                else
                {
                    DailysettingViewController *dailyVC = [[DailysettingViewController alloc]init];
                    dailyVC.uid = uid;
                    //[EaseMobSDK easeMobRegisterAppWithAccount:uid password:KHuanxin HUDShowInView:dailyVC.view];
                    
                    //环信聊天登录，增加自动登录功能
                    [self loginHuanxinWithUid:uid];

//                 [EaseMobSDK easeMobLoginAppWithAccount:uid password:KHuanxin isAutoLogin:NO HUDShowInView:dailyVC.view];
                }
            }
            self.window.rootViewController = talkVC;
        
    }
    

    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];

    //拉伸navBar
    UIImage * img= [UIImage imageNamed:@"nav_bg.png"];
    img = [img stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    
    [[UINavigationBar appearance]setBackgroundImage:img forBarMetrics:(UIBarMetricsDefault)];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // 环信聊天
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //环信聊天
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //环信聊天
    [[EaseMob sharedInstance] applicationWillTerminate:application];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"uid"];
}


//远程推送回调
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    //将得到的deviceToken传给SDK
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}


//远程推送回调
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    // 注册deviceToken失败
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}


#warning FIXME 这里收不到远程推送的内容
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [[EaseMob sharedInstance] application:application didReceiveRemoteNotification:userInfo];

}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "come.yonglibao.HeadPortrait" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HeadPortrait" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HeadPortrait.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


/**
 *  登录环信聊天，设置聊天监听代理，
 *
 *  @param uid 当前用户uid
 */
- (void)loginHuanxinWithUid:(NSString *)uid
{
    
#warning TalkLog
    TalkLog(@"TalkLog:LINE %d ==>loginHuanxinWithUid%@", __LINE__, uid);
    //环信聊天登录，增加自动登录功能
    BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];// 判断是否已经自动登录
    if (!isAutoLogin) {
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:uid
                                                            password:KHuanxin
                                                          completion:^(NSDictionary *loginInfo, EMError *error) {
                                                              // 设置自动登录
                                                              [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                                              
                                                          } onQueue:nil];
    }
    
    //注册一个环信聊天监听对象到监听列表中
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //更新环信推送的推送信息
    [self updataEaseMobPUshNoificationOptions];
}


/**
 *  更新环信推送的推送信息
 */
- (void)updataEaseMobPUshNoificationOptions
{
    //设置推送信息
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
#warning TODO 获取用户名称
    options.nickname = @"MarkFan";
    options.displayStyle = 1;
    
    [EaseMobSDK easeMobUpdatePushOptions:options completion:^(EMPushNotificationOptions *options, EMError *error) {
    }];
}

#pragma EaseMobListening 环信聊天事件监听 start

/**
 *  用户将要自动登录的回调
 *
 *  @param loginInfo 登录的用户信息
 *  @param error     错误信息
 */
- (void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
//#warning TalkLog
//    TalkLog(@"TalkLog:LINE %d ==>willAutoLoginWithInfo%@", __LINE__, loginInfo);
}


/**
 *  用户自动登录完成后的回调
 *
 *  @param loginInfo 登录的用户信息
 *  @param error     错误信息
 */
- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
//#warning TalkLog
//    TalkLog(@"TalkLog:LINE %d ==>didAutoLoginWithInfo%@", __LINE__, loginInfo);
    
}


/**
 *  收到离线透传消息
 *
 *  @param offlineCmdMessages 消息列表
 */
- (void)didReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages{
//#warning TalkLog
//    TalkLog(@"TalkLog:LINE %d ==>didReceiveOfflineCmdMessages%@", __LINE__, @"");
}


/**
 *  已发送消息后的回调
 *
 *  @param message 消息信息
 *  @param error   错误信息
 */
- (void)didSendMessage:(EMMessage *)message error:(EMError *)error{
//#warning TalkLog
//    TalkLog(@"TalkLog:LINE %d ==>didSendMessage%@", __LINE__, message.messageBodies);
    
}


/**
 * 接收到离线信息后的回调
 *
 *  @param offlineMessages 离线消息列表
 */
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages{
//#warning TalkLog
//    TalkLog(@"TalkLog:LINE %d ==>didReceiveOfflineMessages%@", __LINE__, offlineMessages);
    
}


/**
 *  接收到在线消息后的回调
 *
 *  @param message 消息信息
 */
- (void)didReceiveMessage:(EMMessage *)message{
    
    //声音，震动，弹窗提示
    [self showEaseMobNotificationWithMessage:message];

    // 如果正在聊天对象的uid与接收到的消息的uid相同，则不更新小红点，否则更新小红点
    if (![CurrentTalkerUid isEqualToString:message.from]) {
        
        // 1. 获取并更新缓存中未读聊天消息数
        int allEaseMobMessageCounts = [self updateEaseMobMessageCountsWith:message.from];
        
        // 2.设置聊天视图VoiceViewController tabbar上聊天通知小红点，设置app图标上的通知小红点
        [ViewControllerUtil showVoiceViewVCTabbarBadgeAndAppIconBadgeWithNumber:allEaseMobMessageCounts];
    }
}


/**
 *  未读消息数改变时的回调
 */
- (void)didUnreadMessagesCountChanged{
//#warning TalkLog
//    TalkLog(@"TalkLog:LINE %d ==>didUnreadMessagesCountChanged%@", __LINE__, @"");
    
}

#pragma EaseMobListening 环信聊天事件监听 end
/**
 *  获取并更新缓存中未读环信聊天消息数
 *  @param messageSenderId 消息发送者的uid
 *  @return int 当前未读消息总数
 *
 *  消息数的数据结构：
 *   {
 *     "EaseMobUnreaderMessageCount":
 *       {
 *         "senderId": "count",
 *         "senderId": "count",
 *         "senderId": "count",
 *         "senderId": "count",
 *         ...
 *       }
 *   }
 *   
 *   @param senderId: 消息发送者的uid
 *   @param count:    消息个数
 */
- (int)updateEaseMobMessageCountsWith:(NSString *)messageSenderId{
    
    // 1.获取缓存中存在的消息数据
    NSDictionary *easeMobMessageCountsDic = [[NSUserDefaults standardUserDefaults] objectForKey:EaseMobUnreaderMessageCount];
    
    // 2. 若消息数据存在，更新消息数据，统计所有未读消息个数
    //    若消息数据不存在，根据发送者uid在缓存中加入新的消息数据
    int allCount = 0;
    NSMutableDictionary *newEaseMobMessageCountsDic = [[NSMutableDictionary alloc]init];
    BOOL hasSender = false;//获取到的消息数据中是否有当前发送者的数据
    
    //  2.1若消息数据存在
    if (easeMobMessageCountsDic != nil) {
        for(NSString *senderIdStr in easeMobMessageCountsDic.allKeys){
            NSString *senderCount = (NSString *)easeMobMessageCountsDic[senderIdStr];
            
            //若当前sender的数据在旧消息数据中，消息count加一
            if ([messageSenderId isEqualToString:senderIdStr]) {
                allCount = senderCount.intValue + allCount + 1;
                senderCount = [NSString stringWithFormat:@"%d", senderCount.intValue + 1];
                
                hasSender = true;
            }else{
                allCount += senderCount.intValue;
            }
            
            [newEaseMobMessageCountsDic setValue:senderCount forKey:senderIdStr];
        }
        
        //若当前sender的数据不在在旧消息数据中，根据uid设置一条新的消息数据
        if (hasSender == false) {
            [newEaseMobMessageCountsDic setValue:@"1" forKey:messageSenderId];
            allCount++;
        }

    // 2.2 若消息数据不存在，设置新的消息数据
    }else{
        allCount = 1;
        [newEaseMobMessageCountsDic setValue:@"1" forKey:messageSenderId];
    }
    
    // 3.将新的消息数量存入缓存
    [[NSUserDefaults standardUserDefaults] setObject:newEaseMobMessageCountsDic forKey:EaseMobUnreaderMessageCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return allCount;
}


/**
 *  收到环信消息后的声音震动和弹框提示
 *
 *  @param message 消息内容
 */
- (void)showEaseMobNotificationWithMessage:(EMMessage *)message{
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    switch (state) {
        case UIApplicationStateActive:
            [self playSoundAndVibration];
            break;
        case UIApplicationStateInactive:
            [self playSoundAndVibration];
            break;
        case UIApplicationStateBackground:
            [self showNotificationWithMessage:message];
            break;
        default:
            break;
    }

}


/**
 *  收到消息时，播放音频和震动
 */
- (void)playSoundAndVibration{
#warning TalkLog
    TalkLog(@"TalkLog:LINE %d ==>playSoundAndVibration%@", __LINE__, @"");
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}


/**
 *  本地消息提示
 *
 *  @param message 信息内容
 */
#warning FIXME 推送会连发两次,iOS 9.0以后的有的问题（远程推送也有这个问题）
-(void)showNotificationWithMessage:(EMMessage *)message{
    
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:@"MessageType"];
    [userInfo setObject:message.conversationChatter forKey:@"ConversationChatter"];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


/**
 *  注册远程推送
 */
- (void)registerRemoteNotification{
    
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}



@end
