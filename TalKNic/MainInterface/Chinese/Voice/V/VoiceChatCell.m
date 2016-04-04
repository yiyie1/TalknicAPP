//
//  VoiceChatCell.m
//  TalkNic
//
//  Created by fanjia on 16/4/4.
//  Copyright © 2016年 TalKNik. All rights reserved.
//

#define kAvatarViewW 60.0f
#define KTimeLabelW 120.0f
#define kRightArrowW 10.0f
#define kVoiceChatCellH 80.0f
#define kBadgeW 22.0f


#import "VoiceChatCell.h"
#import "VoiceCellModel.h"

@interface VoiceChatCell()
{
    //数据模型
    VoiceCellModel *_cellModel;
}

@end

@implementation VoiceChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    
    return self;
}


/**
 *  创建视图模板
 */
- (void)creatUI{
    
    // 1.创建头像
    self.avatarView = [[UIImageView alloc]initWithFrame:kCGRectMake(KMargin, KMargin, kAvatarViewW, kAvatarViewW)];
    self.avatarView.backgroundColor = [UIColor yellowColor];
    self.avatarView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:self.avatarView];
    
    // 2.创建名字
    self.nameLabel = [[UILabel alloc]initWithFrame:kCGRectMake(CGRectGetMaxX(self.avatarView.frame), KMargin, kWidth - kAvatarViewW - KMargin * 4 - KTimeLabelW, KMargin * 2)];
    self.nameLabel.text = @"Name";
    self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    [self.contentView addSubview:self.nameLabel];
    
    // 3.剩余时间
    self.leftTimeLabel = [[UILabel alloc]initWithFrame:kCGRectMake(kWidth - KTimeLabelW - KMargin, self.nameLabel.frame.origin.y, KTimeLabelW, self.nameLabel.frame.size.height)];
    self.leftTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0f];
    self.leftTimeLabel.text = @"14.0 mins left";
    [self.contentView addSubview:self.leftTimeLabel];
    
    // 4.聊天描述
    self.desLabel = [[UILabel alloc]initWithFrame:kCGRectMake(CGRectGetMaxX(self.avatarView.frame), CGRectGetMaxY(self.nameLabel.frame) + KMargin / 2, kWidth - KMargin * 7 - kRightArrowW - kAvatarViewW, kAvatarViewW - self.nameLabel.frame.size.height - KMargin)];
    self.desLabel.text = @"Audio message!";
    self.desLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0];
    [self.contentView addSubview:self.desLabel];
    
    // 5.右边箭头
    self.rightIcon = [[UIButton alloc]initWithFrame:kCGRectMake(kWidth - kRightArrowW - KMargin * 5, CGRectGetMaxY(self.leftTimeLabel.frame), kRightArrowW, kRightArrowW * 1.5)];
    [self.contentView addSubview:self.rightIcon];
}


/**
 *  给cell填充数据
 *
 *  @param cellModel cell的数据模型
 */
- (void)creatVoiceChatCellWithData:(VoiceCellModel *)cellModel
{
    _cellModel = cellModel;
    
    //设置头像
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:cellModel.pic]];
    //设置名称
    self.nameLabel.text = cellModel.username;
    //设置剩余时间
    self.leftTimeLabel.text = cellModel.leftTime;
    //设置聊天描述
    self.desLabel.text = cellModel.chatDes;
    //设置小红点
    self.badge = cellModel.badgeNumber;
    
    //选中cell时背景图片
    if ([cellModel.chatDes isEqualToString:@"Audio message!"]) {
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"msg_select_area_bg.png"]];
    }else{
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:nil];
    }
    
}

/**
 *  设置小红点的显示
 *
 *  @param badge 小红点数
 */
- (void)setBadge:(NSString *)badge{

    _badge = badge;
    
    // 没有聊天通知，显示箭头
    if ([self.badge isEqualToString:@""] || [self.badge isEqualToString:@"0"] || self.badge == nil) {
        [self.rightIcon setTitle:nil forState:UIControlStateNormal];
        [self.rightIcon setBackgroundImage:[UIImage imageNamed:@"msg_list_next_arrow.png"] forState:UIControlStateNormal];
        self.rightIcon.backgroundColor = nil;
        self.rightIcon.frame = kCGRectMake(kWidth - kRightArrowW - KMargin * 5, CGRectGetMaxY(self.leftTimeLabel.frame), kRightArrowW, kRightArrowW * 2);
        self.rightIcon.clipsToBounds = NO;
    }else{
        //有聊天通知， 显示小红点
        self.rightIcon.frame = kCGRectMake(kWidth - kBadgeW - KMargin * 5, CGRectGetMaxY(self.leftTimeLabel.frame) + KMargin, kBadgeW, kBadgeW);
        [self.rightIcon setBackgroundImage:nil forState:UIControlStateNormal];
        [self.rightIcon setTitle:self.badge forState:UIControlStateNormal];
        [self.rightIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.rightIcon.backgroundColor = [UIColor redColor];
        self.rightIcon.titleLabel.font = [UIFont fontWithName:@"Helveticaeue-Medium" size:12.0f];
        self.rightIcon.clipsToBounds = YES;
        self.rightIcon.layer.cornerRadius = 12.0f;
    }

}


- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
