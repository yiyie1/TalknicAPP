//
//  TalkTabBar.m
//  TalkNic
//
//  Created by Talknic on 15/10/22.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "TalkTabBar.h"
@interface TalkTabBar()
@property (nonatomic,weak)UIButton *plusBtn;
@property (nonatomic,weak)UILabel *match;
@end
@implementation TalkTabBar

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *plusBtn = [[UIButton alloc]init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"main_btn_match_50%.png"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"main_btn_match_100%.png"] forState:UIControlStateHighlighted];
        [plusBtn setImage:[UIImage imageNamed:@"main_btn_match_50%.png"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"main_btn_match_100%.png"] forState:UIControlStateHighlighted];
//        [plusBtn setTitle:@"Match" forState:(UIControlStateNormal)];
//        [plusBtn setTitle:@"Match" forState:(UIControlStateHighlighted)];
//        plusBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:14.0];
//        plusBtn.titleLabel.textAlignment = nste
         plusBtn.size = plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}
-(void)plusClick
{
    /*if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }else
    {
        [self removeFromSuperview];
    }*/
}
- (void)layoutSubviews
{

    [super layoutSubviews];
    
    UILabel *match = [[UILabel alloc]init];
    match.frame = CGRectMake(self.width *0.461, self.height *0.75, 30, 10);
    match.text = AppMatch;
    match.numberOfLines = 0;
    match.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    match.textAlignment = NSTextAlignmentCenter;
    match.textColor = [UIColor colorWithRed:40/255.0 green:140/255.0 blue:222/255.0 alpha:1.0];
    [self addSubview:match];
    self.match = match;
    // 1.设置中间按钮的位置
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height * 0.26;
    
    
    // 2.设置其他tabbarButton的位置和尺寸
    CGFloat tabbarButtonW = self.width / 5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            child.width = tabbarButtonW ;
            // 设置x
            child.x = tabbarButtonIndex * tabbarButtonW ;
            
            // 增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
        }
    }

}
@end
