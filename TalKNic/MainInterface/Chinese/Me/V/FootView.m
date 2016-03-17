//
//  FootView.m
//  TalKNic
//
//  Created by Talknic on 15/12/4.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import "FootView.h"
#import "SDCycleScrollView.h"
@implementation FootView 

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:kCGRectMake(0, -20, self.frame.size.width , 14)];
        _titleLabel.center = CGPointMake(kWidth / 2.3, 20);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
       
        _titleLabel.text = @"Ads / Coupon";
        [self addSubview:_titleLabel];
        
//        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame), 375 - 20, self.frame.size.height - CGRectGetMaxY(_titleLabel.frame))];
//        _imageView.image = [UIImage imageNamed:@"me_ads_image.png"];
//        [self addSubview:_imageView];
    }
    return self;
}


@end
