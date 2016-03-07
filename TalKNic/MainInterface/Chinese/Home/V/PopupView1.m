//
//  PopupView1.m
//  TalKNic
//
//  Created by ldy on 15/11/16.
//  Copyright (c) 2015年 TalKNic. All rights reserved.
//

#import "PopupView1.h"

@implementation PopupView1

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pop = [[PopupView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width - 132, [UIScreen mainScreen].bounds.size.height  - 428)];
        _pop.layer.cornerRadius = 10;
        _pop.layer.masksToBounds = YES;
        _pop.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.width / 2);
        [_pop.button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_pop];
        
        
    }
    return self;
}
-(void)buttonAction:(UIButton *)button
{
    if (_pop.titleLabel2.frame.origin.x != 0) {
        //使原来label消失   更换控件
        _pop.titleLabel2.frame = CGRectMake(0, 0, 0, 0);
        _pop.selectview = [[SelectView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_pop.titleLabel.frame) + 1, _pop.frame.size.width - 40, (_pop.frame.size.height - CGRectGetMaxY(_pop.headImage.frame) - 50) / 2)];
        [self.pop addSubview:_pop.selectview];
        //第一个label的内容换掉
        _pop.titleLabel.text = @"Daliy Topic:";
        _pop.titleLabel.frame = kCGRectMake(20, 85, 150, 10);
        _pop.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        _pop.bio.text =@"";
//        self.topic2 = [[UILabel alloc]initWithFrame:kCGRectMake(20, 90, 250, 40)];
//        _topic2.text =
        //中间分割线去掉
        _pop.fengeLabel.frame = CGRectMake(0, 0, 0, 0);
        //按钮图标换掉
        
    }else
    {
        //使视图消失，返回到上一界面
        self.frame = CGRectMake(0, 0, 0, 0);
        _pop.frame = CGRectMake(0, 0, 0, 0);
        
    }
}
@end
