//
//  VoiceCell.h
//  TalKNic
//
//  Created by ldy on 15/11/19.
//  Copyright (c) 2015年 TalKNic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Voice;
@interface VoiceCell : UITableViewCell
@property (nonatomic,strong)Voice *voice;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *date;

@property (weak, nonatomic) IBOutlet UILabel *userMessage;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@end
