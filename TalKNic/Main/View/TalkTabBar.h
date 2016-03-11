//
//  TalkTabBar.h
//  TalkNic
//
//  Created by Talknic on 15/10/22.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TalkTabBar;
@protocol TalkTabBarDelegate <UITabBarDelegate>

@optional
-(void)tabBarDidClickPlusButton:(TalkTabBar *)tabBar;

@end

@interface TalkTabBar : UITabBar

@property (nonatomic,weak)id<TalkTabBarDelegate> delegate;

@end
