//
//  BalanceCell.h
//  TalKNic
//
//  Created by Talknic on 16/1/11.
//  Copyright © 2016年 TalKNik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *messageLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;

@end
