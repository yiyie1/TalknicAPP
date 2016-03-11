//
//  ForeignerTabBarController.m
//  TalKNic
//
//  Created by Talknic on 15/11/27.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import "ForeignerTabBarController.h"
#import "FeedsViewController.h"
#import "ForeignerVoiceViewController.h"
#import "ForeignerDailyTopicViewController.h"
#import "ForeignerMeViewController.h"
#import "TalkNavigationController.h"

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
    FeedsViewController *feeds = [[FeedsViewController alloc] init];
    [self addChildVc:feeds title:AppFeeds image:kFeeds selectedImage:kFeedsSelected];
    
    ForeignerVoiceViewController *voice = [[ForeignerVoiceViewController alloc] init];
    [self addChildVc:voice title:AppVoice image:kVoiceImage selectedImage:kVoiceSelected];
    
    ForeignerDailyTopicViewController *dailyVC = [[ForeignerDailyTopicViewController alloc]init];
    [self addChildVc:dailyVC title:AppVoice image:kDailyTopicImage selectedImage:kDailyTopicSelected];
    
//    ForeignerMeViewController *meVC = [[ForeignerMeViewController alloc]init];
//    meVC.title = @"Me";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chinese" bundle:nil];
    ForeignerMeViewController *me = [storyboard instantiateViewControllerWithIdentifier:@"fmeVC"];
    [self addChildVc:me title:AppMe image:kMEImage selectedImage:kMEImageSelected];
    me.uid = _uid;

    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVc.title = title;
    // 设置子控制器的图片
    childVc.tabBarItem.image = [[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = TalkColor(211, 211, 211);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = TalkColor(105, 105, 105);
    
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    TalkNavigationController *nav = [[TalkNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
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
