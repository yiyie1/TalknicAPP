//
//  HomeViewController.h
//  TalkNic
//
//  Created by Talknic on 15/10/20.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *homecollectview;
@property (weak, nonatomic) IBOutlet UIView *zhedangbanview; //遮挡板

@property (weak, nonatomic) IBOutlet UIView *beijingView;
@property (weak, nonatomic) IBOutlet UIImageView *detailimage1;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UIButton *dianzangBtn;
@property (weak, nonatomic) IBOutlet UIButton *pingfenBtn;
@property (weak, nonatomic) IBOutlet UILabel *dianzaiLb;
@property (weak, nonatomic) IBOutlet UILabel *pingfenLb;

@property (weak, nonatomic) IBOutlet UILabel *bioLb;
@property (weak, nonatomic) IBOutlet UILabel *dailyTopicLb1;
@property (weak, nonatomic) IBOutlet UILabel *dailyTopicLb2;

@property (weak, nonatomic) IBOutlet UILabel *jieshaoLb;
@property (weak, nonatomic) IBOutlet UILabel *topicLb;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *fengexian2;
@property (weak, nonatomic) IBOutlet UIView *fengexian3;
@property (weak, nonatomic) IBOutlet UIView *xiaofengexian1;
@property (weak, nonatomic) IBOutlet UIView *xiaofengexian2;
@property (weak, nonatomic) IBOutlet UIButton *youhuiquanBtn;// 优惠券
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;// 价格
@property (weak, nonatomic) IBOutlet UILabel *couponsLb;
@property (weak, nonatomic) IBOutlet UILabel *rmbLb;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@end
