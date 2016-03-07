//
//  ForeignerTabBarController.m
//  TalKNic
//
//  Created by ldy on 15/11/27.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import "ForeignerTabBarController.h"
#import "ForeignerFeedsViewController.h"
#import "ForeignerVoiceViewController.h"
#import "ForeignerDailyTopicViewController.h"
#import "ForeignerMeViewController.h"
@interface ForeignerTabBarController ()

@end

@implementation ForeignerTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self layoutForeigner];
}
-(void)layoutForeigner
{
    ForeignerFeedsViewController *feedsVC = [[ForeignerFeedsViewController alloc]init];
    feedsVC.title =@"Feeds";
    
    UINavigationController *feedsNV = [[UINavigationController alloc]initWithRootViewController:feedsVC];
    feedsNV.tabBarItem.image = [UIImage imageNamed:@"main_btn_feeds_50%.png"];
    feedsNV.tabBarItem.selectedImage = [UIImage imageNamed:@"main_btn_feeds_100%.png"];
    
    
    ForeignerVoiceViewController *voiceVC = [[ForeignerVoiceViewController alloc]init];
    voiceVC.title = @"Voice";
    
    UINavigationController *voiceNV = [[UINavigationController alloc]initWithRootViewController:voiceVC];
    voiceNV.tabBarItem.image = [UIImage imageNamed:@"main_btn_vioce_50%.png"];
    voiceNV.tabBarItem.selectedImage = [UIImage imageNamed:@"main_btn_voice_100%.png"];
    
    ForeignerDailyTopicViewController *dailyVC = [[ForeignerDailyTopicViewController alloc]init];
    dailyVC.title = @"Daily Topic";
    
    UINavigationController *dailyNV = [[UINavigationController alloc]initWithRootViewController:dailyVC];
    dailyNV.tabBarItem.image = [UIImage imageNamed:@"daily_topic_icon.png"];
    dailyNV.tabBarItem.selectedImage = [UIImage imageNamed:@"daily_topic_icon_click.png"];

//    ForeignerMeViewController *meVC = [[ForeignerMeViewController alloc]init];
//    meVC.title = @"Me";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chinese" bundle:nil];
    ForeignerMeViewController *me = [storyboard instantiateViewControllerWithIdentifier:@"fmeVC"];
    me.title = @"Me";
    UINavigationController *meNV = [[UINavigationController alloc]initWithRootViewController:me];
    meNV.tabBarItem.image = [[UIImage imageNamed:@"main_btn_me_50%.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    meNV.tabBarItem.selectedImage = [[UIImage imageNamed:@"main_btn_me_100%.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.viewControllers = @[feedsNV,voiceNV,dailyNV,meNV];
    

    self.selectedIndex = 0;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
