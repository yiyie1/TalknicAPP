//
//  FVoiceCell.m
//  TalKNic
//
//  Created by Talknic on 15/11/27.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import "FVoiceCell.h"
#import "FVoice.h"

@interface  FVoiceCell()









@end
@implementation FVoiceCell
-(void)setFvoice:(FVoice *)fvoice
{
    _fvoice = fvoice;
    self.userFName.text = fvoice.name;
    self.date.text = fvoice.date1;
    self.userFMessage.text = fvoice.message;
    self.userFMessage.numberOfLines = 0;
    self.userImage.image = fvoice.userI;
}

- (IBAction)toView:(id)sender {
}


//- (void)awakeFromNib {
//    
//}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    
//}

@end
