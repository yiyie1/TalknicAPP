//
//  Setting.h
//  TalKNic
//
//  Created by Talknic on 15/12/9.
//  Copyright © 2015年 TalkNic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Setting : NSObject

@property (nonatomic,strong)NSArray *grouping;

+(id)settingWithGroup:(NSArray *)group;



@end
