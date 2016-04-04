//
//  VoiceChatCell.h
//  TalkNic
//
//  Created by fanjia on 16/4/4.
//  Copyright © 2016年 TalKNik. All rights reserved.
//

@class VoiceCellModel;
#import <UIKit/UIKit.h>

@interface VoiceChatCell : UITableViewCell

//头像
@property (nonatomic, strong)UIImageView *avatarView;
//名称
@property (nonatomic, strong)UILabel *nameLabel;
//剩余时间
@property (nonatomic, strong)UILabel *leftTimeLabel;
//聊天描述
@property (nonatomic, strong)UILabel *desLabel;
//通知小红点
@property (nonatomic, strong)NSString *badge;
//右边箭头
@property (nonatomic, strong)UIButton *rightIcon;


//给cell填充数据
- (void)creatVoiceChatCellWithData:(VoiceCellModel *)cellModel;

@end
