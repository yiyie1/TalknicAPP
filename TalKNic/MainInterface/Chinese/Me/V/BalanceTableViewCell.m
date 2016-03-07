//
//  BalanceTableViewCell.m
//  TalKNic
//
//  Created by ldy on 15/12/4.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import "BalanceTableViewCell.h"
#import "Balance2ViewController.h"
@implementation BalanceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  


}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageview = [[UIImageView alloc] initWithFrame:kCGRectMake( 375 - 30, 231 / 4 - 5, 5, 10)];
        self.imageview.image = [UIImage imageNamed:@"me_balance_next_icon.png"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_imageview addGestureRecognizer:tap];
        [self.contentView addSubview:self.imageview];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:kCGRectMake(0, 0, 375, 231 / 6)];
//        _titleLabel.center = CGPointMake(375 / 2, 231 / 6);
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = AppBalance;
        [self.contentView addSubview:_titleLabel];
        
        self.label = [[UILabel alloc] initWithFrame:kCGRectMake(0, CGRectGetMaxY(_titleLabel.frame) +10, 375, 231 / 4 )];
//        _label.center = CGPointMake(375 / 2, 231 / 4 + 231 / 8);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:35.0];
        _label.text = @"￥20.00";
        _label.textColor = [UIColor blueColor];
        [self.contentView addSubview:_label];
        
        
    }
    return self;
}
-(void)tapAction
{
    
    
}
@end
