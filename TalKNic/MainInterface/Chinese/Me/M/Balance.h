//
//  Balance.h
//  TalKNic
//
//  Created by Talknic on 15/11/17.
//  Copyright (c) 2015年 TalKNic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Balance : NSObject

@property (nonatomic,strong)NSArray *grouping;
+(id)balancesetupWithGrouping:(NSArray *)group;
@end
