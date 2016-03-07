//
//  PopupView.h
//  TalKNic
//
//  Created by ldy on 15/11/7.
//  Copyright (c) 2015年 TalKNic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectView.h"
@interface PopupView : UIView

@property (nonatomic,strong)UIImageView *backgroundView;
@property (nonatomic,strong)UIImageView *headImage;//头像
@property (nonatomic,strong)UILabel *nameLabel;//姓名
@property (nonatomic,strong)UILabel *nameLabel2;//国籍
@property (nonatomic,strong)UIImageView *likeImage;//喜欢
@property (nonatomic,strong)UILabel *likeLabel;//喜欢数
@property (nonatomic,strong)UIImageView *collectImage;//收藏
@property (nonatomic,strong)UILabel *collectLabel;//收藏数
@property (nonatomic,strong)UILabel *titleLabel;//话题
@property (nonatomic,strong)UILabel *bio;
@property (nonatomic,strong)UILabel *topic;
@property (nonatomic,strong)UILabel *titleLabel2;//名称
@property (nonatomic,strong)UILabel *fengeLabel;//分割线
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIButton *button;//按钮

@property (nonatomic,strong)SelectView *selectview;


@end
