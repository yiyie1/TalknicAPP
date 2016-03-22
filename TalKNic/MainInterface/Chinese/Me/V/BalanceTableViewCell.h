//
//  BalanceTableViewCell.h
//  TalKNic
//
//  Created by Talknic on 15/12/4.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceTableViewCell : UITableViewCell

@property (nonatomic, copy)NSString *uid;
@property (strong,nonatomic)UILabel *titleLabel;

@property (strong,nonatomic)UILabel *label;

@property (strong,nonatomic)UIImageView *imageview;

@end
