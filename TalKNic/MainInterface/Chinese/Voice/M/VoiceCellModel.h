//
//  VoiceCellModel.h
//  TalkNic
//
//  Created by fanjia on 16/4/3.
//  Copyright © 2016年 TalKNik. All rights reserved.
//


/**
 *  VoiceViewController中每个cell的Model
 *
 */

#import <Foundation/Foundation.h>

@interface VoiceCellModel : NSObject

@property (nonatomic, copy)NSString *bio;
@property (nonatomic, copy)NSString *occupation;
@property (nonatomic, copy)NSString *paytime;
@property (nonatomic, copy)NSString *order_id;
@property (nonatomic, copy)NSString *pic;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *user_teacher_id;
@property (nonatomic, copy)NSString *username;

@property (nonatomic, strong)NSString *leftTime;
@property (nonatomic, strong)NSString *chatDes;
@property (nonatomic, strong)NSString *badgeNumber;



- (void)setVoiceCellModelWith:(NSDictionary *)dic chatterRole:(NSString *)chatterRole badgeNumber:(NSString *)badgeNumber;


@end
