//
//  FVoiceCell.h
//  TalKNic
//
//  Created by ldy on 15/11/27.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FVoice;
@interface FVoiceCell : UITableViewCell
@property (nonatomic,strong)FVoice *fvoice;
@property (weak, nonatomic) IBOutlet UILabel *userFName;

@property (weak, nonatomic) IBOutlet UILabel *date;

@property (weak, nonatomic) IBOutlet UILabel *userFMessage;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@end
