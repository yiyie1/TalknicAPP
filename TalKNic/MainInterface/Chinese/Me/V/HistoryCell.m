//
//  HistoryCell.m
//  TalKNic
//
//  Created by ldy on 15/11/30.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import "HistoryCell.h"
#import "History.h"
@interface HistoryCell()

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *date;

@property (weak, nonatomic) IBOutlet UILabel *userMessage;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end


@implementation HistoryCell

-(void)setHistory:(History *)history
{
    
    _history = history;
    
    self.userName.text = history.name;
    self.date.text = history.date1;
    self.userMessage.text = history.message;
    self.userImage.image  = history.userI;
    self.time.text = history.time;
}

- (IBAction)toView:(id)sender {
}



@end
