//
//  AppDelegate.m
//  TalkNic
//
//  Created by Talknic on 15/10/9.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//
#import "ScrollViewController.h"

//#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate.h"
#import "ChoosePeopleViewController.h"
#import "TalkTabBarViewController.h"
#import "SignupViewController.h"
#import "LoginViewController.h"
#import "RootViewController.h"
#import "MeViewController.h"
#import "AppDelegate+ShareSDK.h"

#import "EaseMobSDK.h"
#import "UIImage+HKExtension.h"
#import "Foreigner0ViewController.h"
#import "InformationViewController.h"
//#import "UMSocial.h"

#import "HomeViewController.h"
#import "FeedsViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
//- (void)showLoginView
//{
//    //跳到登陆界面
//    __weak AppDelegate *weakSelf = self;
//    
//    LoginViewController *aLoginViewController = [[LoginViewController alloc] init];
//    
//    switch (weakSelf.mainTabBarController.selectedIndex) {
//        case 0:
//        {
//            [weakSelf.iHomePageViewController presentViewController:aLoginViewController animated:YES completion:^{
//                
//            }];
//        }
//            break;
//        case 1:
//        {
//            [weakSelf.iLoanlistsViewController presentViewController:aLoginViewController animated:YES completion:^{
//                
//            }];
//        }
//            break;
//        case 2:
//        {
//            [weakSelf.iMyAssetsController presentViewController:aLoginViewController animated:YES completion:^{
//                
//            }];
//        }
//            break;
//        case 3:
//        {
//            [weakSelf.iMoreViewController presentViewController:aLoginViewController animated:YES completion:^{
//                
//            }];
//        }
//            break;
//            
//        default:
//            break;
//    }
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //集成分享登陆功能
    [self addShareSDKWithapplication:application didFinishLaunchingWithOptions:launchOptions];
    
    //环信注册
    [EaseMobSDK easeMobRegisterSDKWithAppKey:kEaseKey apnsCertName:nil application:application didFinishLaunchingWithOptions:launchOptions];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"userId"];
    NSString *str = [user objectForKey:kChooese_ChineseOrForeigner];
    TalkLog(@"uid: %@, role: %@", uid, str);
    TalkLog(@"Server Address: %@", PATH_GET_CODE);

    if (![user boolForKey:@"UseApp"])
    {
        ChoosePeopleViewController *chooseVC = [[ChoosePeopleViewController alloc]init];
        UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:chooseVC];
        self.window.rootViewController = naVC;
    }
    else
    {
            
        if (uid.length == 0)
        {
            LoginViewController  *loginVC = [[LoginViewController alloc]init];
            UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
            self.window.rootViewController = naVC;
        }
        else
        {

            TalkTabBarViewController *talkVC = [[TalkTabBarViewController alloc]init];
            talkVC.uid = uid;
                    
            if ([str isEqualToString:@"Chinese"])
            {
                talkVC.identity = CHINESEUSER;
                HomeViewController *home = [[HomeViewController alloc]init];
                [EaseMobSDK easeMobLoginAppWithAccount:uid password:KHuanxin isAutoLogin:NO HUDShowInView:home.view];
            }
            else
            {
                talkVC.identity = FOREINERUSER;
                FeedsViewController *feeds = [[FeedsViewController alloc]init];
                [EaseMobSDK easeMobLoginAppWithAccount:uid password:KHuanxin isAutoLogin:NO HUDShowInView:feeds.view];
            }
            self.window.rootViewController = talkVC;

        }
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

#warning 支付修改开始 10.2
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    NSString * absolute = url.absoluteString;
    if ([absolute hasPrefix:@"alisdktalknic"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"支付宝app调用");
            
        }];
    }
    return YES;
}
#warning 支付修改结束 10.2



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"uid"];
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


@end
