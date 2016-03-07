//
//  PopupView.m
//  TalKNic
//
//  Created by ldy on 15/11/7.
//  Copyright (c) 2015年 TalKNic. All rights reserved.
//

#import "PopupView.h"

@implementation PopupView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"discover_pay_bg.png"]];
        //头像
        self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, 60, 60)];
        self.headImage.layer.cornerRadius = 30;
        self.headImage.layer.masksToBounds = YES;
        self.headImage.image = [UIImage imageNamed:@"main_btn_me_100%.png"];

        [self addSubview:_headImage];
        //标题
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImage.frame) + 10, CGRectGetMinY(_headImage.frame), self.frame.size.width - 110, 20)];

        _nameLabel.text = @"Elishia Raskin";
        _nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:14.0];
        [self addSubview:_nameLabel];
        self.nameLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImage.frame) + 10, CGRectGetMaxY(_nameLabel.frame), self.frame.size.width - 110, 20)];

        _nameLabel2.text = @"California,USA";
        _nameLabel2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        [self addSubview:_nameLabel2];
        //喜欢
        self.likeImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImage.frame) + 10, CGRectGetMaxY(_nameLabel2.frame)+3, 19, 16)];
        self.likeImage.image = [UIImage imageNamed:@"discover_like_red.png"];
        [self addSubview:_likeImage];
        self.likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_likeImage.frame), CGRectGetMaxY(_nameLabel2.frame), (self.frame.size.width - 110 ) / 4, 20)];
        _likeLabel.text = @"11";
        _likeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];

        [self addSubview:_likeLabel];
        //收藏
        self.collectImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_likeLabel.frame), CGRectGetMaxY(_nameLabel2.frame), 22, 21)];
        _collectImage.image = [UIImage imageNamed:@"discover_star_yellow.png"];
        [self addSubview:_collectImage];
        self.collectLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_collectImage.frame), CGRectGetMaxY(_nameLabel2.frame), (self.frame.size.width - 110 ) / 4 + 5, 20)];
        _collectLabel.text = @"4.7";
        _collectLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        [self addSubview:_collectLabel];
        
        
        //话题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_headImage.frame) -15, self.frame.size.width - 40, (self.frame.size.height - CGRectGetMaxY(_headImage.frame) - 50) / 2)];

        _titleLabel.text = @"Bio:";
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
       
       
        self.bio = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLabel.frame) -25, 250, 50)];
        _bio.text = @"Live in Los Angeles for 2 years!\nNow I am in Shanghai.\nFunny, Chatting, make friends with you guys!";
        _bio.numberOfLines = 0;
        _bio.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:0];
        _bio.font = [UIFont systemFontOfSize:10.0f];
        [self addSubview:_bio];
        
        self.fengeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLabel.frame) +20, self.frame.size.width - 40, 1)];
        _fengeLabel.backgroundColor = [UIColor grayColor];
        [self addSubview:_fengeLabel];
        
        
        self.titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLabel.frame) + 5, self.frame.size.width - 40, (self.frame.size.height - CGRectGetMaxY(_headImage.frame) - 50) / 2)];
//        _titleLabel2.backgroundColor = [UIColor yellowColor];
        _titleLabel2.text = @"Daily Topic:";
        _titleLabel2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        [self addSubview:_titleLabel2];
        
        self.topic = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, 250, 40)];
        _topic.text = @"What is the most spontaneous thing you \nhave done lately?";
        _topic.numberOfLines = 0;
        _topic.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:0];
        _topic.font = [UIFont systemFontOfSize:10.0f];
        [self addSubview:_topic];
        
        self.button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _button.frame = CGRectMake(self.frame.size.width / 2 - 15, CGRectGetMaxY(_titleLabel2.frame) + 15, 56/2, 57/2);
        [_button setBackgroundImage:[UIImage imageNamed:@"discover_pay_ok.png"] forState:(UIControlStateNormal)];
        [self addSubview:_button];
        
        
    }
    return self;
}

@end
