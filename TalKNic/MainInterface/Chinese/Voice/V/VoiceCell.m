//
//  VoiceCell.m
//  TalKNic
//
//  Created by Talknic on 15/11/19.
//  Copyright (c) 2015年 TalKNic. All rights reserved.
//

#import "VoiceCell.h"
#import "Voice.h"
@interface VoiceCell ()



@end
@implementation VoiceCell

-(void)setVoice:(Voice *)voice
{
    _voice = voice;
    
    self.userName.text = voice.name;
    self.date.text = voice.date1;
    self.userMessage.numberOfLines = 0;
    self.userMessage.text = voice.message;
    self.userImage.image = voice.userI;
}


- (IBAction)toView:(id)sender {
    
    
    
    
}



@end
